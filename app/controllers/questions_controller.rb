class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :new, :show, :create_result, :result ] # ログインが必要なアクションを設定

  def new
  end

  def show
    begin
      @question = Question.find(params[:id])
      puts params[:id]
      @quiz = @question.quiz
      @choices = Choice.where(question_id: @question.id)
      choices_adjust(@choices)
      @quiz = @question.quiz
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("Question not found: #{e.message}")
      flash[:alert] = "指定された質問が見つかりませんでした。"
      redirect_to root_path
    end
  end

  def create
  end

  def create_result
  @question = Question.find(params[:question_id])
  user_answer = params[:answer]
  correct_answer = @question.correct_answer
  is_correct = (user_answer.to_s == correct_answer.to_s)

  session[:is_correct] = is_correct

  if user_signed_in?
    past_answer = PastAnswer.find_or_initialize_by(
      question_id: @question.id,
      user_id: current_user.id
    )

    if past_answer.update(
      answer_content: user_answer,
      answer_result: is_correct
    )
      Rails.logger.info("PastAnswer saved successfully: #{past_answer.inspect}")
    else
      Rails.logger.error("Failed to save PastAnswer: #{past_answer.errors.full_messages.join(', ')}")
      flash[:alert] = "回答の保存に失敗しました。"
      redirect_to root_path and return
    end
  end

  redirect_to result_question_path(question_id: @question.id, is_correct: is_correct)
end


  def result
    @question = Question.find(params[:id])
    @quiz = @question.quiz
    @choices = Choice.where(question_id: @question.id)
    @quiz = @question.quiz

    if user_signed_in?
      @past_answer = PastAnswer.find_by(question_id: @question.id, user_id: current_user.id)

      # もし `PastAnswer` が見つからない場合はエラー表示
      unless @past_answer
        flash[:alert] = "回答履歴が見つかりませんでした。"
        redirect_to root_path and return
      end

      @is_correct = @past_answer.answer_result
    else
      @is_correct = session[:is_correct]
      session.delete(:is_correct)  # 正誤情報をクリア
    end

    @next_question = Question.where("id > ? AND quiz_id = ?", @question.id, @quiz.id).order(:id).first
    @has_next_question = @next_question.present?

    # メタタグの設定
    prepare_meta_tags(@quiz)
  end

  def random
    tag_name = params[:tag]
    @random_quizzes = Quiz.joins(:tags).where(tags: { name: tag_name }).order("RANDOM()").limit(10)

    if @random_quizzes.empty?
      flash[:alert] = "指定されたタグに関連するクイズが見つかりませんでした。"
      redirect_to root_path and return
    end

    # クイズのIDリストをセッションに保存
    session[:random_quiz_ids] = @random_quizzes.pluck(:id)
    session[:current_question_index] = 0
    redirect_to random_show_questions_path
  end

  def random_show
    quiz_ids = session[:random_quiz_ids] || []
    index = session[:current_question_index] || 0

    if quiz_ids.empty? || index >= quiz_ids.length
      flash[:alert] = "ランダムクイズが見つかりませんでした。"
      redirect_to root_path and return
    end

    # クイズを取得
    @quiz = Quiz.find(quiz_ids[index])
    @question = @quiz.questions.order("RANDOM()").first
    @choices = @question.choices

    # セッションに現在の問題IDを保存
    session[:question_id] = @question.id
  end

  def random_create_result
    @question = Question.find(params[:question_id])
    user_answer = params[:answer]
    correct_answer = @question.correct_answer
    is_correct = (user_answer.to_s == correct_answer.to_s)

    Rails.logger.info "ユーザーの回答 (user_answer): #{user_answer} (型: #{user_answer.class})"
    Rails.logger.info "正解 (correct_answer): #{correct_answer} (型: #{correct_answer.class})"
    Rails.logger.info "判定結果: #{is_correct}"

    # セッションに結果を保存
    session[:question_id] = @question.id
    session[:is_correct] = is_correct

    if user_signed_in?
      past_answer = PastAnswer.find_or_initialize_by(
        question_id: @question.id,
        user_id: current_user.id
      )

      if past_answer.update(answer_content: user_answer, answer_result: is_correct)
        Rails.logger.info("PastAnswer saved successfully: #{past_answer.inspect}")
      else
        Rails.logger.error("Failed to save PastAnswer: #{past_answer.errors.full_messages.join(', ')}")
        flash[:alert] = "回答の保存に失敗しました。"
        redirect_to root_path and return
      end
    end

    redirect_to random_result_questions_path
  end

  def random_result
    quiz_ids = session[:random_quiz_ids] || []
    index = session[:current_question_index] || 0

    if index >= quiz_ids.length
      flash[:notice] = "ランダムクイズが終了しました。"
      redirect_to root_path and return
    end

    # セッションから問題IDを取得
    @question = Question.find(session[:question_id])
    @quiz = @question.quiz
    @choices = @question.choices
    @is_correct = session[:is_correct]

    # `session[:is_correct]` が nil の場合は、DB から取得
    if @is_correct.nil? && user_signed_in?
      @is_correct = PastAnswer.find_by(question_id: @question.id, user_id: current_user.id)&.answer_result
      Rails.logger.info "データベースから再取得した判定: #{@is_correct}"
    end

    # 次の問題へ進めるか判定
    session[:current_question_index] += 1
    @has_next_question = session[:current_question_index] < quiz_ids.length
    @next_question_path = random_show_questions_path if @has_next_question
  end
  
  
  
  private

  def page_title(title = "")
    base_title = "Programming Question"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def prepare_meta_tags(quiz)
    # このimage_urlにMiniMagicで設定したOGPの生成した合成画像を代入する
    # image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(quiz.title)}&questions_count=#{quiz.questions_count}&tags=#{CGI.escape(quiz.tags.pluck(:name).join(','))}"
    set_meta_tags og: {
      site_name: "Programming Question",
      title: quiz.title,
      description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
      type: "website",
      url: url_for(controller: "quiz_posts", action: "show", id: quiz.id, only_path: false),
      # image: image_url,
      locale: "ja-JP"
    },
    twitter: {
      card: "summary_large_image",
      site: "@study_kogoro"
      # image: image_url
    }
  end

  def authenticate_user!
    unless user_signed_in? # ユーザーがログインしているかを確認
      flash[:alert] = "ログインが必要です。"
      redirect_to new_user_session_path
    end
  end

  def choices_adjust(choices)
    choices.each do |choice|
      if choice.choice1.include?("<")
        choice.choice1.gsub!("<", "＜").gsub!(">", "＞")
      end
      if choice.choice2.include?("<")
        choice.choice2.gsub!("<", "＜").gsub!(">", "＞")
      end
      if choice.choice3.include?("<")
        choice.choice3.gsub!("<", "＜").gsub!(">", "＞")
      end
      if choice.choice4.include?("<")
        choice.choice4.gsub!("<", "＜").gsub!(">", "＞")
      end
    end
  end
end

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :new ] # ログインが必要なアクションを設定

  def new
  end

  def show
    begin
      @question = Question.find(params[:id])
      puts params[:id]
      @quiz = @question.quiz
      @choices = Choice.where(question_id: @question.id)
      shuffle_and_adjust_choices(@choices)
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
  redirect_to result_question_path(question_id: @question.id, is_correct: is_correct)

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


  def result
    @question = Question.find(params[:id])
    @quiz = @question.quiz
    @choices = Choice.where(question_id: @question.id)
    @quiz = @question.quiz

    @past_answer = PastAnswer.find_by(question_id: @question.id, user_id: current_user.id)
    unless @past_answer
      flash[:alert] = "回答履歴が見つかりませんでした。"
      redirect_to root_path and return
    end

    @next_question = Question.where("id > ? AND quiz_id = ?", @question.id, @quiz.id).order(:id).first
    @has_next_question = @next_question.present?

    # メタタグの設定
    prepare_meta_tags(@quiz)
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

  def shuffle_and_adjust_choices(choices)
    choices.each do |choice|
      # 全ての選択肢を配列に入れる
      all_choices = [
        choice.choice1,
        choice.choice2,
        choice.choice3,
        choice.choice4
      ]

      # シャッフルして各属性に再代入
      shuffled = all_choices.shuffle
      choice.choice1 = shuffled[0]
      choice.choice2 = shuffled[1]
      choice.choice3 = shuffled[2]
      choice.choice4 = shuffled[3]

      # 正解の位置を記録（1-4の番号）
      @correct_answer = shuffled.index(all_choices[0]) + 1
      @question.update(correct_answer: @correct_answer)
    end
  end
end

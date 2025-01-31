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
  redirect_to question_result_path(question_id: @question.id, is_correct: is_correct)

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
    # 画像のテキストは、クイズのタイトル、問題数、タグを使う
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(quiz.title)}&questions_count=#{quiz.questions_count}&tags=#{CGI.escape(quiz.tags.pluck(:name).join(','))}"
    quiz_url = url_for(controller: "quiz_posts", action: "show", id: quiz.id, only_path: false)

    set_meta_tags(
      title: quiz.title,
      description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
      og: {
          site_name: "Programming Question",
          title: quiz.title,
          description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
          type: "website",
          url: quiz_url,
          image: image_url,
          local: "ja-JP"
      },
      twitter: {
          card: "summary_large_image",
          site: "@study_kogoro", # 公式アカウントのユーザー名を入れる
          title: quiz.title,
          description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
          image: image_url
      }
    )
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

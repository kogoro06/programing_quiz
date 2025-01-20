class QuizPostsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @quizzes = Quiz.eager_load(:user, :tags).all
    @tags = Tag.all
    @newest_quizzes = Quiz.includes(:tags).order(created_at: :desc).first(6)
    @current_user = current_user
  end

  def show
    @quiz = Quiz.includes(:tags, :questions).find(params[:id])
    @tags = Tag.all

    # メタタグの設定
    # 画像のテキストは、クイズのタイトル、問題数、タグを使う
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(@quiz.title)}&questions_count=#{@quiz.questions_count}&tags=#{CGI.escape(@quiz.tags.pluck(:name).join(','))}"
    quiz_url = url_for(controller: "quiz_posts", action: "show", id: @quiz.id, only_path: false)

    set_meta_tags(
      title: @quiz.title,
      description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
      og: {
          site_name: "Programming Question",
          title: @quiz.title,
          description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
          type: "website",
          url: quiz_url,
          image: image_url,
          local: "ja-JP"
      },
      twitter: {
          card: "summary_large_image",
          site: "@study_kogoro", # 公式アカウントのユーザー名を入れる
          title: @quiz.title,
          description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
          image: image_url
      }
    )
  end

  def new
    @quiz = Quiz.new
    @tags=Tag.all
    if current_user.admin?
      30.times do
        question = @quiz.questions.build
        question.choices.build # 1回だけchoicesを作成
      end
    else
      10.times do
        question = @quiz.questions.build
        question.choices.build # 1回だけchoicesを作成
      end
    end
  end

  def create
    @tags=Tag.all
    @quiz = Quiz.new(quiz_params.merge(author_user_id: current_user.id))

    @quiz.questions = @quiz.questions.select { |q| q.question.present? }

    if @quiz.save
      redirect_to quiz_post_path(@quiz), notice: "クイズを投稿しました！"
    else
      if current_user.admin?
        30.times do
          question = @quiz.questions.build
          question.choices.build # 1回だけchoicesを作成
        end
      else
        10.times do
          question = @quiz.questions.build
          question.choices.build # 1回だけchoicesを作成
        end
      end
      render :new, status: :unprocessable_entity
    end
    Rails.logger.info "Received tag_ids: #{params[:quiz][:tag_ids]}"
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      :title,
      tag_ids: [],
      questions_attributes: [
        :id,
        :question,
        :correct_answer,
        :answer_source,
        :explanation,
        :_destroy,
        :question_image,
        :explanation_image,
        choices_attributes: [
          :id,
          :choice1,
          :choice2,
          :choice3,
          :choice4,
          :_destroy
        ]
      ]
    )
  end
end

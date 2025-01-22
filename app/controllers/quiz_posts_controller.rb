class QuizPostsController < ApplicationController
  # 設定したprepare_meta_tagsをprivateにあってもpostコントローラー以外にも使えるようにする
  helper_method :prepare_meta_tags
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @quizzes = Quiz.eager_load(:user, :tags).all
    @tags = Tag.all
    @newest_quizzes = Quiz.includes(:tags).order(created_at: :desc).first(6)
    @current_user = current_user
  end

  def show
    @quiz = Quiz.includes(:tags, :questions).find(params[:id])
    @tags = Tag.all
    prepare_meta_tags(@quiz)
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

  # show画面の内容がシェアできれば良いので、設定をコントローラーで行う。
  def prepare_meta_tags(quiz)
    # このimage_urlにMiniMagicで設定したOGPの生成した合成画像を代入する
    # image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(quiz.title)}&questions_count=#{quiz.questions_count}&tags=#{CGI.escape(quiz.tags.pluck(:name).join(','))}"
    set_meta_tags og: {
      site_name: "Programming Question",
      title: quiz.title,
      description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
      type: "website",
      url: url_for(controller: 'quiz_posts', action: 'show', id: quiz.id, only_path: false),
      # image: image_url,
      locale: "ja-JP"
    },
    twitter: {
      card: "summary_large_image",
      site: "@study_kogoro",  
      # image: image_url
    }
  end

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

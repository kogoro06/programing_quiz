class QuizPostsController < ApplicationController
  # 設定したprepare_meta_tagsをprivateにあってもpostコントローラー以外にも使えるようにする
  helper_method :prepare_meta_tags
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [ :index, :search, :autocomplete ]

  def index
    @quizzes = Quiz.eager_load(:user, :tags).all
    set_common_variables
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

  def edit
    @quiz = Quiz.find(params[:id])
    @tags = Tag.all
    unless @quiz.user == current_user
      redirect_to root_path, alert: "権限がありません"
    end

    # 現在の質問の数を取得
    existing_questions_count = @quiz.questions.count

    # 最大10問になるように新しいquestionを追加
    (10 - existing_questions_count).times do
      question = @quiz.questions.build
      question.choices.build # 1回だけchoicesを作成
    end
  end

  def update
    @quiz = Quiz.find_by(id: params[:id])
    @tags = Tag.all
    return redirect_to root_path, alert: "クイズが見つかりません" unless @quiz

    # 空の question を除外
    quiz_questions = quiz_params[:questions_attributes]&.values || []
    quiz_questions.reject! { |q| q[:question].blank? && q[:correct_answer].blank? && q[:choices_attributes].values.all? { |c| c.values.all?(&:blank?) } }

    # 更新するパラメータを再構築
    update_params = quiz_params.merge(questions_attributes: quiz_questions)

    if @quiz.update(update_params)
      redirect_to quiz_post_path(@quiz), notice: "クイズを更新しました！"
    else
      # バリデーションエラー時に新しい質問を追加
      existing_questions_count = @quiz.questions.count
      (10 - existing_questions_count).times do
        question = @quiz.questions.build
        question.choices.build # 1回だけchoicesを作成
      end

      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @quizzes = @q.result(distinct: true).eager_load(:user, :tags)
    set_common_variables
    render :index
  end

  def autocomplete
    query = params[:q]
    require "moji"

    # 入力をひらがなに変換
    hiragana_query = query.tr("ァ-ン", "ぁ-ん")

    @quizzes = Quiz.eager_load(:user)
                   .where("quizzes.title ILIKE ? OR users.name ILIKE ? OR quizzes.name_hiragana ILIKE ?",
                         "%#{query}%", "%#{query}%", "%#{hiragana_query}%")
                   .limit(10)

    render json: QuizSerializer.new(@quizzes)
  end

  def generate_wrong_choices
    question = params[:question].to_s.gsub(/<[^>]*>/, "") # HTMLタグを除去
    raise "Question is empty" if question.blank?
    
    existing_choices = Array(params[:existing_choices])
    remaining_count = [4 - existing_choices.length, 0].max
  
    prompt = <<~PROMPT
      以下のプログラミングに関する問題の選択肢を#{remaining_count}つ生成してください。
  
      【問題】
      #{question}
  
      【正解の選択肢】
      #{existing_choices.join("\n")}
  
      生成する際の条件：
      ・必ず#{remaining_count}つの誤った選択肢を生成すること
      ・正解の選択肢と重複しない
      ・以下の点を考慮した誤った選択肢を作成：
        - 明確に誤りとなる内容にする
        - 初学者がよく間違える概念を含める
        - 正解と似て非なる表現を使用
        - 実際のプログラミングでよくある誤解を反映
      ・正解の選択肢と同じ文体・形式で記述
      ・文末はこちらが入力した語尾に合わせる
      ・1行に1つの選択肢
  
      【出力形式】
      選択肢
    PROMPT
  
    begin
      response = ChatgptService.call(prompt)
      raise "Received empty response from ChatGPT API" if response.blank?
  
      choices = response.split("\n").map(&:strip).reject { |choice|
        choice.empty? ||
        choice.include?("選択肢") ||
        choice.match?(/^\d+\./) ||
        existing_choices.include?(choice)
      }
  
      raise "No valid choices generated" if choices.empty?
  
      choices = choices.first(remaining_count)
  
      render json: { status: "success", choices: choices }
    rescue => e
      Rails.logger.error "ChatGPT API Error: #{e.message}"
      Rails.logger.error "Response: #{response.inspect}"
      render json: { status: "error", message: e.message }, status: :unprocessable_entity
    end
  end
  

  private

  def set_common_variables
    @tags = Tag.all
    @newest_quizzes = Quiz.includes(:tags).order(created_at: :desc).first(6)
    @current_user = current_user
  end

  # show画面の内容がシェアできれば良いので、設定をコントローラーで行う。
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

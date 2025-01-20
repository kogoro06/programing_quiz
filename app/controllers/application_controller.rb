class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_user
  before_action :set_profile

  before_action :configure_permitted_parameters, if: :devise_controller?

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


  private

  def page_title(title = "")
    base_title = "Programming Question"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def set_user
    @user = current_user
  end

  def set_profile
    @profile = current_user&.profile if user_signed_in?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end

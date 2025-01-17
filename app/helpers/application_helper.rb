module ApplicationHelper
  def prepare_meta_tags(quiz)
    # 画像のテキストは、クイズのタイトル、問題数、タグを使う
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(quiz.title)}&questions_count=#{quiz.questions_count}&tags=#{CGI.escape(quiz.tags.pluck(:name).join(','))}"
    set_meta_tags og: {
                      site_name: "Programming Question",
                      title: quiz.title,
                      description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
                      type: "website",
                      url: request.original_url,
                      image: image_url("proque_ogp1.png"),
                      local: "ja-JP"
                  },
                  twitter: {
                      card: "summary_large_image",
                      site: "@study_kogoro", # 公式アカウントのユーザー名を入れる
                      image: image_url
                  }
  end
  
  def page_title(title = "")
    base_title = "Programming Question"
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end

module ApplicationHelper
  def prepare_meta_tags(quiz)
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(quiz.title)}"
    set_meta_tags og: {
                      site_name: 'Programming Question',
                      title: "テストタイトル",
                      description: 'Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。',
                      type: 'website',
                      url: request.original_url,
                      image: image_url('proque_ogp1.png'),
                      local: 'ja-JP'
                  },
                  twitter: {
                      card: 'summary_large_image',
                      site: '@study_kogoro', # 公式アカウントのユーザー名を入れる
                      image: image_url
                  }
  end
end

module ApplicationHelper
  def default_meta_tags
    {
      site: 'Programming Question',
      title: 'ページのタイトルが決まったら指定する',
      reverse: true,
      charset: 'utf-8',
      description: 'ページのディスクリプションが決まったら指定する',
      keywords: 'キーワード1,キーワード2',
      canonical: request.original_url,
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@study_kogoro', # 公式アカウントのユーザー名を入れる
        image: image_url('ogp.png')
      }
    }
  end
end

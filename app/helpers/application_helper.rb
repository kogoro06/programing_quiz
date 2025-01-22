module ApplicationHelper
  def default_meta_tags
    {
      site: "Programming Question",
      title: "Programming Question",
      reverse: true,
      charset: "utf-8",
      description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
      canonical: request.original_url,
      og: {
        site_name: "Programming Question",
        title: "Programming Question",
        description: "Programming Questionはプログラミングのクイズを投稿・共有できるサイトです。",
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@study_kogoro",
        image: image_url("ogp.png")
      }

    }
  end
  def page_title(title = "")
    base_title = "Programming Question"
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end

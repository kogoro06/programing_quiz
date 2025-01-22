class ImagesController < ApplicationController
  skip_before_action :require_login, raise: false

  def ogp
    Rails.logger.info("ogp_params: #{ogp_params}")
    image = OgpCreator.build(ogp_params[:text], ogp_params[:questions_count], ogp_params[:tags]).tempfile.open.read
    send_data image, type: "image/png", disposition: "inline"
  end

  private

  def ogp_params
    params.permit(:text, :questions_count, :tags)
  end
end

class ImagesController < ApplicationController
  def ogp
    image = OgpCreator.build(ogp_params[:text], ogp_params[:questions_count], ogp_params[:tags]).tempfile.open.read
    send_data image, type: "image/png", disposition: "inline"
  end

  private

  def ogp_params
    params.permit(:text, :questions_count, :tags)
  end
end

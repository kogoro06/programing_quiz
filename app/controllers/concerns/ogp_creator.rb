class OgpCreator
  require 'mini_magick'
  BASE_IMAGE_PATH = './app/assets/images/proque_ogp1.png'
  GRAVITY = 'center'
  FONT = './app/assets/fonts/M_PLUS_Rounded_1c/MPLUSRounded1c-Black.ttf'
  FONT_SIZE = 100
  INDENTION_COUNT = 30 # 1行の文字数
  ROW_LIMIT = 8
  LINE_HEIGHT = 120 # 行の高さ

  def self.build(text, questions_count, tags)
    text_lines = prepare_text("タイトル: #{text}")
    questions_count_lines = prepare_text("問題数: #{questions_count}")
    tags_lines = prepare_text("タグ: #{tags}")
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      config.font FONT
      config.fill 'black'
      config.gravity GRAVITY
      config.pointsize FONT_SIZE

      # テキストを行ごとに描画
      text_lines.each_with_index do |line, index|
        position = "0,#{index * LINE_HEIGHT}"
        config.draw "text #{position} '#{line}'"
      end

      # 質問数のテキストを行ごとに描画
      questions_count_lines.each_with_index do |line, index|
        position = "0,#{(text_lines.size + index) * LINE_HEIGHT}"
        config.draw "text #{position} '#{line}'"
      end

      # タグのテキストを行ごとに描画
      tags_lines.each_with_index do |line, index|
        position = "0,#{(text_lines.size + questions_count_lines.size + index) * LINE_HEIGHT}"
        config.draw "text #{position} '#{line}'"
      end
    end
    image
  end

  private

  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT]
  end
end
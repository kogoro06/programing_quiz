namespace :quiz do
  desc "既存のクイズの読み仮名を更新"
  task update_readings: :environment do
    Quiz.find_each do |quiz|
      quiz.save
    end
  end
end
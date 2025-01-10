class UserProfileForm
  include ActiveModel::Model       # モデルの機能を利用するために記載
  include ActiveModel::Attributes  # モデルの機能を利用するために記載

  # 属性の定義
  attribute :bio,                :string
  attribute :studying_languages, :string
  attribute :github_link,        :string
  attribute :x_link,             :string
  attribute :user_id,            :string
  attribute :name,               :string

  # バリデーション
  validates :bio,                length: { maximum: 250 }
  validates :studying_languages, length: { maximum: 250 }
  validates :github_link,        length: { maximum: 250 }
  validates :x_link,             length: { maximum: 250 }
  validates :name,               presence: true, length: { in: 1..20 }

  attr_accessor :user, :profile
  # userとprofileのモデルのインスタンスを初期化
  def initialize(user, profile, params = {})
    # 親クラスの初期化を行う
    super(params)

    # モデルのインスタンスを初期化
    @user = user
    @profile = profile

    # 各入力項目を初期化
    Rails.logger.debug "Received params in profile edit initialize: #{params.inspect}"
    self.name = @user.name
    self.bio = @profile.bio
    self.studying_languages = @profile.studying_languages
    self.x_link = @profile.x_link
    self.github_link = @profile.github_link
  end

  def save(user_profile_form_params)
    return set_error_and_return_false("Validation faild") unless valid?

    # パラメータ確認
    Rails.logger.debug "Received params in profile updating: #{user_profile_form_params.inspect}"
    ActiveRecord::Base.transaction do
      @user.update!(
        name: user_profile_form_params[:name]
      )
      @profile.update!(
        bio: user_profile_form_params[:bio],
        studying_languages: user_profile_form_params[:studying_languages],
        github_link: user_profile_form_params[:github_link],
        x_link: user_profile_form_params[:x_link]
      )
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    set_error_and_return_false("Record invalid: #{e.message}")
  end

  private

  def set_error_and_return_false(message)
    @error_message = message
    false
  end
end

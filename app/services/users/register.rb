class Users::Register
  attr_reader :user

  def initialize(params)
    @params = params
    build_user
  end

  def call
    return false unless @user.valid?

    User.transaction do
      @user.save!
      assign_role
    end

    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound
    false
  end

  private

  def build_user
    @user = User.new(
      username: @params[:username],
      email: @params[:email],
      password: @params[:password],
      password_confirmation: @params[:password_confirmation]
    )
  end

  def assign_role
    role = Role.find_by!(code: "user")
    @user.user_roles.create!(role: role)
  end
end
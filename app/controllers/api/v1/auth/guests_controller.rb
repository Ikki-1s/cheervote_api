class Api::V1::Auth::GuestsController < DeviseTokenAuth::SessionsController
  # ゲストユーザーでログイン
  def sign_in
    @resource = User.guest
    @token = @resource.create_token
    @resource.save!
    render_create_success
  end
end

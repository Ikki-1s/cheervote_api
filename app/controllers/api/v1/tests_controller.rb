class Api::V1::TestsController < ApplicationController
  # before_action :authenticate_api_v1_user!

  def index
    render json: { message: 'hello, world' }
  end
end

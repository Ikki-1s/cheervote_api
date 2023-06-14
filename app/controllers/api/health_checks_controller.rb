class Api::HealthChecksController < ApplicationController
  def index
    logger.info "============================================================"
    logger.info "RequestUrl: #{request.url}"
    render json: { message: 'hello, world', status: 200 }, status: :ok
  end
end

class Api::V1::HrPrBlocksController < ApplicationController
  def index
    hr_pr_blocks = HrPrBlock.select(:id, :block_name, :quota)
    render json: hr_pr_blocks
  end

  def show
    hr_pr_block = HrPrBlock.select(:id, :block_name, :quota).where(id: params[:id])
    render json: hr_pr_block
  end
end

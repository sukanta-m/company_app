class BranchesController < ApplicationController
  before_action :set_company
  before_action :set_branch, only: [:show, :update, :destroy]

  # GET /branches
  def index
    @branches = @company.branches

    render json: @branches
  end

  # GET /branches/1
  def show
    render json: @branch
  end

  # POST /branches
  def create
    @branch = @company.branches.new(branch_params)

    if @branch.save
      render json: @branch, status: :created, location: @branch
    else
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /branches/1
  def update
    if @branch.update(branch_params)
      render json: @branch
    else
      render json: @branch.errors, status: :unprocessable_entity
    end
  end

  # DELETE /branches/1
  def destroy
    @branch.destroy
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_branch
    @branch = @company.branches.find(params[:id])
  end

  def branch_params
    params.require(:branch).permit(:name, :line1, :line2, :city, :state, :country, :zip)
  end
end

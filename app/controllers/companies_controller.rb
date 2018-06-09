class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.all

    render json: @companies
  end

  # GET /companies/startup
  def startup
    @companies = Company.startup

    render json: @companies
  end

  # GET /companies/mid_size
  def mid_size
    @companies = Company.mid_size

    render json: @companies
  end

  # GET /companies/established
  def established
    @companies = Company.established

    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company.serializable_hash(include: :branches)
  end

  # POST /companies
  def create
    branches = params[:company][:branches]
    @company = Company.new(company_params)

    branches.each do |branch|
      @company.branches << Branch.new(branch_params(branch))
    end if branches.present?

    if @company.save
      render json: @company.serializable_hash(include: :branches), status: :created
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    branches = params[:company][:branches]

    if @company.update(company_params)
      @company.create_or_update_branches(branches.map { |b| branch_params(b) }) if branches.present?

      render json: @company.serializable_hash(include: :branches)
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    if @company.destroy
      render status: :ok
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :website, :reg_id, :timings, :established_date, branches: [])
  end

  def branch_params(branch)
    branch.require(:startup).permit(:name, :line1, :line2, :city, :state, :country, :zip)
  end
end

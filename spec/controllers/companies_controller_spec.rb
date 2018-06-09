require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:invalid_company_attributes) {
    {
      website: "google.com",
      established_date: Time.now,
      reg_id: 1234,
      timings: "09:00-18:00"
    }
  }
  let(:valid_company_attributes) { invalid_company_attributes.merge(name: "Google") }
  let(:invalid_branch_attributes) {
    {
      line1: "Apt #14, Suite #22",
      line2: "ABC Street, BCDTown",
      city: "XYCity",
      state: "Foo",
      country: "Bar",
      zip: "0102"
    }
  }
  let(:valid_branch_attributes) { invalid_branch_attributes.merge(name: "branch 1") }

  context "validation" do
    context "company" do
      context "when name is blank" do
        it "should return status code 422" do
          post :create, params: { company: { name: "" } }
          expect(response.code.to_i).to be 422
        end
      end

      context "when reg_id is not numberical" do
        it "should return status code 422" do
          post :create, params: { company: { name: "company 1", reg_id: "reg id" } }
          expect(response.code.to_i).to be 422
        end
      end

      context "branch" do
        context "when name is blank" do
          it "should return status code 422" do
            post :create, params: { company: { name: "company1", branches: [{startup: valid_branch_attributes.merge(name: "")}] } }
            expect(response.code.to_i).to be 422
          end
        end

        context "when line1 is blank" do
          it "should return status code 422" do
            post :create, params: { company: { name: "company1", branches: [{startup: valid_branch_attributes.merge(line1: "")}] } }
            expect(response.code.to_i).to be 422
          end
        end

        context "when city is blank" do
          it "should return status code 422" do
            post :create, params: { company: { name: "company1", branches: [{startup: valid_branch_attributes.merge(city: "")}] } }
            expect(response.code.to_i).to be 422
          end
        end

        context "when state is blank" do
          it "should return status code 422" do
            post :create, params: { company: { name: "company1", branches: [{startup: valid_branch_attributes.merge(state: "")}] } }
            expect(response.code.to_i).to be 422
          end
        end

        context "when country is blank" do
          it "should return status code 422" do
            post :create, params: { company: { name: "company1", branches: [{startup: valid_branch_attributes.merge(country: "")}] } }
            expect(response.code.to_i).to be 422
          end
        end

        context "when zip is blank" do
          it "should return status code 422" do
            post :create, params: { company: { name: "company1", branches: [{startup: valid_branch_attributes.merge(zip: "")}] } }
            expect(response.code.to_i).to be 422
          end
        end
      end
    end
  end

  describe "GET #index" do
    it "should returns a success response" do
      get :index
      expect(response).to be_success
    end

    context "when no companies presents" do
      it "should returns empty list" do
        get :index
        expect(parse_response_body).to be_empty
      end
    end

    context "when companies presents" do
      let!(:company1) { FactoryBot.create(:company, name: 'company1') }
      let!(:company2) { FactoryBot.create(:company, name: 'company2') }

      it "should returns all companies" do
        get :index
        expect(parse_response_body.collect { |d| d["_id"] }).to match_array([company1.id.to_s, company2.id.to_s])
      end
    end
  end

  describe "GET #show" do
    context "when company is exist" do
      let!(:company) { FactoryBot.create(:company, name: "company1") }

      it "should returns a success response" do
        get :show, params: { id: company.to_param }
        expect(response).to be_success
      end

      it "should return company" do
        get :show, params: { id: company.to_param }
        expect(parse_response_body['name']).to eq(company.name)
      end
    end

    context "when company is not exist" do
      it "should throw error" do
        expect {
          get :show, params: { id: "23" }
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end

  describe "POST #create" do
    context "with valid company params" do
      context "without branch" do
        let!(:params) {
          {
            company: valid_company_attributes
          }
        }

        it "should creates a new Company" do
          expect {
            post :create, params: params
          }.to change(Company, :count).by(1)
        end

        it "should returns a success response" do
          post :create, params: params
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with the new company" do
          post :create, params: params
          expect(parse_response_body).not_to be_empty
        end
      end

      context "with branch" do
        let!(:params) {
          {
            company: valid_company_attributes.merge(branches: [{ startup: valid_branch_attributes }])
          }
        }

        it "should creates a new Company and its branches" do
          expect {
            post :create, params: params
          }.to change(Company, :count).by(1)
          expect(Company.last.branches.count).to be 1
        end

        it "should returns a success response" do
          post :create, params: params
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
        end

        it "renders a JSON response with the new company with branches" do
          post :create, params: params
          expect(parse_response_body).not_to be_empty
          expect(parse_response_body["branches"].length).to eq 1
        end
      end
    end

    context "with invalid company params(name is blank)" do
      context "without branch" do
        it "should creates a new Company" do
          expect {
            post :create, params: {
              company: invalid_company_attributes
            }
          }.to change(Company, :count).by(0)
        end

        it "renders a JSON response with errors for new company" do
          post :create, params: { company: invalid_company_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with branch" do
        let!(:params) {
          {
            company: invalid_company_attributes.merge(branches: [{ startup: valid_branch_attributes }])
          }
        }
        it "should not creates a new Company and its branches" do
          expect {
            post :create, params: params
          }.to change(Company, :count).by(0)
        end

        it "renders a JSON response with errors for branches" do
          post :create, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end
  end

  describe "PUT #update" do
    let!(:company) { FactoryBot.create(:company, name: 'company1') }

    context "with valid params" do
      let(:new_attributes) {
        { name: 'Company new' }
      }

      it "renders a JSON response with success" do
        put :update, params: { id: company.to_param, company: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end

      it "updates the requested company" do
        put :update, params: { id: company.to_param, company: new_attributes }
        expect(parse_response_body["name"]).to eq(company.reload.name)
      end

      context "with branches" do
        context "with new branches" do
          it "should create new branches" do
            expect(company.branches.count).to be 0
            put :update, params: { id: company.to_param, company: new_attributes.merge(branches: [{ startup: valid_branch_attributes }]) }
            expect(company.reload.branches.count).to be 1
          end
        end

        context "with existing branches" do
          before do
            company.branches << Branch.new(valid_branch_attributes)
          end

          it "should update existing branches" do
            expect(company.reload.branches.count).to be 1
            expect(company.reload.branches.first.line1).not_to eq "test line1"
            put :update, params: { id: company.to_param, company: new_attributes.merge(branches: [{ startup: valid_branch_attributes.merge(line1: 'test line1') }]) }
            expect(company.reload.branches.first.line1).to eq "test line1"
          end

          it "should return updated branches" do
            put :update, params: { id: company.to_param, company: new_attributes.merge(branches: [{ startup: valid_branch_attributes.merge(line1: 'test line1') }]) }
            expect(parse_response_body['branches'].first['line1']).to eq "test line1"
          end
        end
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        put :update, params: { id: company.to_param, company: {name: ""} }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:company) { FactoryBot.create(:company, name: 'company1') }

    it "renders a JSON response with the company" do
      delete :destroy, params: { id: company.to_param }
      expect(response).to have_http_status(:ok)
    end

    it "destroys the requested company" do
      expect {
        delete :destroy, params: { id: company.to_param }
      }.to change(Company, :count).by(-1)
    end

    context "when company is not exist" do
      it "should throw error" do
        expect {
          get :show, params: { id: "23" }
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end

  describe "GET startup/mid_size/established companies" do
    let!(:statup_company1) { FactoryBot.create(:company, name: 'startup Company 1', established_date: Time.now.to_date) }
    let!(:statup_company2) { FactoryBot.create(:company, name: 'startup Company 2', established_date: 8.years.ago.to_date) }
    let!(:mid_size_company1) { FactoryBot.create(:company, name: 'Midsize Company 1', established_date: 9.years.ago.to_date) }
    let!(:mid_size_company2) { FactoryBot.create(:company, name: 'Midsize Company 2', established_date: 18.years.ago.to_date) }
    let!(:established_company1) { FactoryBot.create(:company, name: 'Established Company 1', established_date: 19.years.ago.to_date) }
    let!(:established_company2) { FactoryBot.create(:company, name: 'Established Company 2', established_date: 30.years.ago.to_date) }

    it "should return statup comapnies" do
      get :startup
      expect(parse_response_body.collect { |d| d["_id"] }).to match_array([statup_company1.id.to_s, statup_company2.id.to_s])
    end

    it "should return mid size comapnies" do
      get :mid_size
      expect(parse_response_body.collect { |d| d["_id"] }).to match_array([mid_size_company1.id.to_s, mid_size_company2.id.to_s])
    end

    it "should return established comapnies" do
      get :established
      expect(parse_response_body.collect { |d| d["_id"] }).to match_array([established_company1.id.to_s, established_company2.id.to_s])
    end
  end

  private

  def parse_response_body
    JSON.parse(response.body)
  end
end

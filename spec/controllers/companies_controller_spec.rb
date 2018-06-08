require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:valid_attributes) {
    { name: "company1" }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      company = Company.create! valid_attributes
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      company = Company.create! valid_attributes
      get :show, params: { id: company.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Company" do
        expect {
          post :create, params: { company: valid_attributes }, session: valid_session
        }.to change(Company, :count).by(1)
      end

      it "renders a JSON response with the new company" do

        post :create, params: { company: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(company_url(Company.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new company" do

        post :create, params: { company: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested company" do
        company = Company.create! valid_attributes
        put :update, params: { id: company.to_param, company: new_attributes }, session: valid_session
        company.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the company" do
        company = Company.create! valid_attributes

        put :update, params: { id: company.to_param, company: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the company" do
        company = Company.create! valid_attributes

        put :update, params: { id: company.to_param, company: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested company" do
      company = Company.create! valid_attributes
      expect {
        delete :destroy, params: { id: company.to_param }, session: valid_session
      }.to change(Company, :count).by(-1)
    end
  end

end

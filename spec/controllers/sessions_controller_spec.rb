require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:valid_attributes) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: user.email,
          password: 'wrong-password'
        }
      }
    end

    context 'with invalid params' do
      before do
        post :create, params: invalid_attributes
      end

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with valid params' do
      before do
        post :create, params: valid_attributes
      end

      it 'returns with an ok status' do
        expect(response).to have_http_status :ok
      end

      it 'returns a valid body' do
        expect(JSON.parse(response.body).keys).to contain_exactly(
          'id', 'name', 'email', 'admin', 'jwt_token', 'created_at', 'updated_at'
        )
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      delete :destroy
    end

    it 'returns with a "no content" status' do
      expect(response).to have_http_status :no_content
    end
  end
end

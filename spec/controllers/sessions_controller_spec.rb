require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    context 'when login params are incorrect' do
      before do
        post :create
      end

      it 'returns unauthorized status' do
        expect(response.status).to eq 401
      end
    end

    context 'when params are correct' do
      before do
        post :create, params: params
      end

      it 'returns ok status' do
        expect(response).to have_http_status(200)
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

    it 'returns no content status' do
      expect(response).to have_http_status(204)
    end
  end
end

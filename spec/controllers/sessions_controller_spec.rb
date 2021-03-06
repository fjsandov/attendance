require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
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

    context 'with invalid params' do
      let(:params) do
        {
          user: {
            email: user.email,
            password: 'wrong-password'
          }
        }
      end

      before do
        post :create, params: params
      end

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with valid params' do
      before do
        post :create, params: params
      end

      context 'when the user is active' do
        it 'returns with an ok status' do
          expect(response).to have_http_status :ok
        end

        it 'returns a valid body' do
          expect(JSON.parse(response.body).keys).to contain_exactly(
            'id', 'name', 'email', 'admin', 'jwt_token', 'created_at', 'updated_at'
          )
        end
      end

      context 'when the user is inactive' do
        let(:user) { create(:inactive_user) }

        it 'returns with an "unauthorized" status' do
          expect(response).to have_http_status :unauthorized
        end
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

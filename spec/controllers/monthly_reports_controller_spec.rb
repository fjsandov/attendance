require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe MonthlyReportsController, type: :controller do
  let(:user) { create(:user) }

  let(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end

  let(:month) { 10 }

  let(:params) do
    {
      user_id: user.id,
      monthly_report: {
        month: month,
        year: 2001
      }
    }
  end

  describe 'POST #create' do
    context 'with unauthenticated request' do
      before { post :create, params: params }

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with authenticated request' do
      before { request.headers.merge!(auth_headers) }

      context 'when the params are valid' do
        it 'returns with a "created" status' do
          post :create, params: params
          expect(response).to have_http_status :created
        end
      end

      context 'when the params are invalid' do
        let(:month) { 13 }

        it 'returns with an unprocessable entity status' do
          post :create, params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:admin) }

  let(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end

  describe 'GET #index' do
    context 'with unauthenticated request' do
      before do
        get :index
      end

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with authenticated request' do
      before do
        request.headers.merge!(auth_headers)
        get :index
      end

      it 'returns with an ok status' do
        expect(response).to have_http_status :ok
      end
    end
  end
end

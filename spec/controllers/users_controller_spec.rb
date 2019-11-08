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

  describe 'POST #create' do
    let(:user_resource) { build(:user) }

    let(:params) do
      {
        user: {
          name: user_resource.name,
          email: user_resource.email,
          password: user_resource.password,
          password_confirmation: user_resource.password,
        }
      }
    end

    context 'with unauthenticated request' do
      before { post :create, params: params }

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with authenticated request' do
      before { request.headers.merge!(auth_headers) }

      it 'creates a new user' do
        expect { post :create, params: params }.to change(User, :count).by(1)
      end

      it 'returns with a "created" status' do
        post :create, params: params
        expect(response).to have_http_status :created
      end
    end
  end

  describe 'PUT #update' do
    let(:user_resource) { create(:user) }
    let(:new_name) { 'New Name' }

    let(:params) do
      {
        id: user_resource.id,
        user: {
          name: new_name
        }
      }
    end

    context 'with unauthenticated request' do
      before { patch :update, params: params }

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with authenticated request' do
      before { request.headers.merge!(auth_headers) }

      before do
        patch :update, params: params
        user_resource.reload
      end

      it 'returns with an ok status' do
        expect(response).to have_http_status :ok
      end

      subject { user_resource.name }
      it { should eq new_name }
    end
  end

  describe 'DELETE #destroy' do
    let(:user_resource) { create(:user) }
    let(:params) do
      { id: user_resource.id }
    end

    context 'with unauthenticated request' do
      before { delete :destroy, params: params }

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with authenticated request' do
      before { request.headers.merge!(auth_headers) }

      before do
        delete :destroy, params: params
        user_resource.reload
      end

      context 'when disabling the authenticated user' do
        let(:params) do
          { id: user.id }
        end

        it 'returns with an unprocessable entity status' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'when disabling another user' do
        subject { user_resource.active }

        it { should be_falsey }

        it 'returns with a no content status' do
          expect(response).to have_http_status :no_content
        end
      end
    end
  end
end

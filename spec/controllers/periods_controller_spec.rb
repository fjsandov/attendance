require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe PeriodsController, type: :controller do
  let(:user) { create(:user) }

  let(:auth_headers) do
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end

  let(:params) do
    { user_id: user.id }
  end

  describe 'GET #index' do
    context 'with unauthenticated request' do
      before { get :index, params: params }

      it 'returns an "unauthorized" status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'with authenticated request' do
      before do
        request.headers.merge!(auth_headers)
        get :index, params: params
      end

      it 'returns with an ok status' do
        expect(response).to have_http_status :ok
      end
    end
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

      context 'when there are not open periods for the user' do
        it 'creates a new period' do
          expect { post :create, params: params }.to change(user.periods, :count).by(1)
        end

        it 'returns with a "created" status' do
          post :create, params: params
          expect(response).to have_http_status :created
        end
      end

      context 'when there is already an open period for the user' do
        before { create(:period, user: user, ended_at: nil)  }

        it 'returns with an unprocessable entity status' do
          post :create, params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:period) { create(:period, user: user, ended_at: nil) }

    let(:params) do
      { user_id: user.id, id: period.id }
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
        period.reload
      end

      context 'when the period is open' do
        subject { period.ended_at }

        it 'returns with an ok status' do
          expect(response).to have_http_status :ok
        end

        it { should_not be_nil }
      end

      context 'when it the period is already closed' do
        let(:period) { create(:period, user: user) }

        it 'returns with an unprocessable entity status' do
          patch :update, params: params
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:period) { create(:period, user: user) }

    let(:params) do
      {
        user_id: user.id,
        id: period.id,
        period_deletion: {
          reason: 'test reason'
        }
      }
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
        period.reload
      end

      context 'when delete a non deleted period' do
        subject { period.period_deletion }

        it { should_not be_nil }

        it 'returns with a no content status' do
          expect(response).to have_http_status :no_content
        end
      end

      context 'when delete an already deleted period' do
        before { delete :destroy, params: params }

        it 'returns with an unprocessable entity status' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end
end

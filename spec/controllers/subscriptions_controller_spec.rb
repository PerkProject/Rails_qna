require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }
    let(:question) { create :question }
    before { user.questions << question }

    context 'when user is not authenticated' do
      it 'returns error 401' do
        post :create, params: { question_id: question.id, format: :js }
        expect(response.status).to eq 401
      end

      it 'does not creates subscription' do
        expect { post :create, params: { question_id: question.id, format: :js } }.not_to change(Subscription, :count)
      end
    end

    context 'when user authenticated' do
      sign_in_user
      context 'when already subscribed' do
        let(:subscription) { create(:subscription, question: question) }
        before { @user.subscriptions << subscription }
        it 'does not create subscription' do
          expect { post :create, params: { question_id: question.id, format: :js } }.not_to change(Subscription, :count)
        end
      end

      context 'when not subscribed' do
        it 'creates subscription' do
          expect { post :create, params: { question_id: question.id, format: :js } }.to change(@user.subscriptions, :count).by 1
        end

        it 'returns status 200' do
          post :create, params: { question_id: question.id, format: :js }
          expect(response.status).to eq 200
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let(:subscription) { create(:subscription) }
    before { user.subscriptions << subscription }

    context 'when user is not authenticated' do
      it 'returns error 401' do
        delete :destroy, params: { id: subscription.id, format: :js }
        expect(response.status).to eq 401
      end

      it 'does not destroy subscription' do
        expect { delete :destroy, params: { id: subscription.id, format: :js } }.not_to change(Subscription, :count)
      end
    end

    context 'when user authenticated' do
      sign_in_user
      before { @user.subscriptions << subscription }

      it 'returns status 200' do
        delete :destroy, params: { id: subscription.id, format: :js }
        expect(response.status).to eq 200
      end
      it 'destroys subscription' do
        expect { delete :destroy, params: { id: subscription.id, format: :js } }.to change(@user.subscriptions, :count).by(-1)
      end
    end
  end
end

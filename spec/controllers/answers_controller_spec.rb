require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { question = create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'valid answer' do
      let(:answer_params) { { answer: attributes_for(:answer), question_id: question } }

      it 'creates answer in database' do
        expect do
          post :create, params: answer_params
        end.to change(question.answers, :count).by(1)

      end

      it 'persists an answer with author' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to change(@user.answers, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, params: answer_params
        expect(response).to redirect_to(question)
      end
    end

    context 'invalid answer' do
      let(:answer_params) { { answer: attributes_for(:invalid_answer), question_id: question } }

      it 'does not create answer in database' do
        expect do
          post :create, params: answer_params
        end.not_to change(Answer, :count)
      end

      it 'renders new' do
        post :create, params: answer_params
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before do
      @question = create(:question, user: @user)
      @answer = create(:answer, question: @question, user: @user)
    end

    context 'author delete you answer' do

      it 'delete answer in database' do
        expect do
          delete :destroy, params: { id: @answer, question_id: @question }
        end.to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: @answer, question_id: @question }
        expect(response).to redirect_to @question
      end
    end

    context 'authenticated user can not delete answer other user' do
      before do
        sign_out(@user)
        sign_in create(:user)
      end

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: @answer, question_id: @question }}.to_not change(Answer, :count)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: @answer, question_id: @question }
        expect(response).to redirect_to @question
      end
      end
  end
end
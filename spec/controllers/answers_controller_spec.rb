require 'rails_helper'
require 'shared_examples/controllers/voted_shared'

RSpec.describe AnswersController, type: :controller do
  it_should_behave_like 'voted'

  let(:question) { question = create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'valid answer' do
      let(:answer_params) { { answer: attributes_for(:answer), question_id: question, format: :js } }

      it 'creates answer in database' do
        expect do
          post :create, params: answer_params
        end.to change(question.answers, :count).by(1)
      end

      it 'persists an answer with author' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(@user.answers, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, params: answer_params
        expect(response).to render_template :create
      end
    end

    context 'invalid answer' do
      let(:answer_params) { { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }

      it 'does not create answer in database' do
        expect do
          post :create, params: answer_params
        end.not_to change(Answer, :count)
      end

      it 'renders new' do
        post :create, params: answer_params
        expect(response).to render_template :create
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
          delete :destroy, params: { id: @answer, question_id: @question }, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: @answer, question_id: @question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated user can not delete answer other user' do
      before do
        sign_out(@user)
        sign_in create(:user)
      end

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: @answer, question_id: @question }, format: :js }.not_to change(Answer, :count)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: @answer, question_id: @question }, format: :js
        expect(response).not_to render_template :destroy
      end
    end
  end

  describe 'PATCH update' do
    sign_in_user

    before do
      @question = create(:question, user: @user)
      @answer = create(:answer, question: @question, user: @user)
    end

    context 'author edit you answer' do
      it 'edit answer with valid params' do
        patch :update, params: { id: @answer, question_id: @question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq @answer
      end

      it 'edit answer with invalid params' do
        patch :update, id: @answer, question_id: @question, format: :js, params: { id: @answer, answer: { body: nil } }
        @answer.reload
        expect(@answer.body).not_to eq nil
      end

      it 'assigns the question' do
        patch :update, params: { id: @answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq @question
      end
    end

    context 'when not the author' do
      sign_in_user

      it 'assigns the requested answer to @answer' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: @answer, format: :js
        }
        expect(assigns(:answer)).to eq(@answer)
      end

      it 'assigns the question' do
        patch :update, params: {
          answer: attributes_for(:answer), question_id: question, id: @answer, format: :js
        }
        expect(assigns(:question)).to eq(@question)
      end

      it 'not change the answer attributes' do
        before_body = @answer.body
        patch :update, params: {
          answer: { body: 'new body' }, question_id: question, id: @answer, format: :js
        }
        @answer.reload
        expect(@answer.body).to eq(before_body)
      end
    end
  end

  describe 'GET #best' do
    sign_in_user

    before do
      @question = create(:question, user: @user)
      @answer = create(:answer, question: @question, user: @user)
    end

    context 'author of question' do
      before do
        @best = @answer.best
        xhr :post, :answer_best, id: @answer.id, question_id: @question.id, format: :js
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq @answer
      end

      it 'change answer accepted status' do
        @answer.reload
        expect(@answer.best).to eq !@best
      end

      it 'render best_answer template' do
        expect(response).to render_template :answer_best
      end
    end

    context 'Non-author of question' do
      it 'can not change the accepted status of answer' do
        sign_out(@user)
        sign_in(create(:user))
        @best = @answer.best
        xhr :post, :answer_best, id: @answer.id, question_id: @answer.question.id, format: :js
        @answer.reload
        expect(@answer.best).to eq @best
      end
    end
  end
end

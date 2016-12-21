require 'rails_helper'
require 'shared_examples/controllers/voted_shared'

RSpec.describe QuestionsController, type: :controller do
  it_should_behave_like 'voted'

  describe 'GET #index' do
    before { get :index }

    it 'renders index' do
      expect(response).to render_template(:index)
    end

    it 'assigns list of all questions to @questions' do
      expect(assigns(:questions)).to match_array(Question.all)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, params: { id: question.id } }

    it 'renders index' do
      expect(response).to render_template(:show)
    end

    it 'assigns @question' do
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'GET #new' do
    sign_in_user

    before  { get :new }

    it 'renders new view' do
      expect(response).to render_template(:new)
    end

    it 'assigns new question model @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'valid question' do
      it 'creates new question in database' do
        expect do
          post 'create', params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'persists a question with author' do
        expect do
          post :create, params: { user_id: @user, question: attributes_for(:question) }
        end.to change(@user.questions, :count).by(1)
      end

      it 'redirects to questions list' do
        post 'create', params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid question' do
      it 'does not create new question in database' do
        expect do
          post 'create', params: { question: attributes_for(:invalid_question) }
        end.not_to change(Question, :count)
      end

      it 'renders new' do
        post 'create', params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'Author delete your question' do
      sign_in_user
      before { @question = create(:question, user: @user) }

      it 'delete question' do
        expect { delete :destroy, params: { id: @question }}.to change(Question,:count).by(-1)
      end

      it 'redirects to questions list' do
        delete :destroy, params: { id: @question }
        expect(response).to redirect_to questions_path
      end
    end

   context 'Non-Author delete your question' do
     sign_in_user
     before do
       @question = create(:question, user: @user)
       sign_out @user
       sign_in(create(:user))
     end

     it 'not delete question' do
       expect { delete :destroy, params: { id: @question }}.to_not change(Question,:count)
     end

     it 'to be successful' do
       delete :destroy, params: { id: @question }
       expect(response).to be_successful
     end
   end

  end
end
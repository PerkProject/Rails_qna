require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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
end
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let!(:comment) { create(:comment, commentable: question) }
  sign_in_user

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves comment to db' do
        expect { process :create, method: :post, params: { comment: attributes_for(:comment), question_id: question }, format: :js
                          }.to change(question.comments, :count).by(1)
      end

      it 'responds with json, status code 201 (created)' do
        process :create, method: :post, params: { comment: attributes_for(:comment), question_id: question }, format: :js

        expect(response.content_type).to eq('text/javascript')
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'does not save comment to db' do
        expect { process :create, method: :post,
                         params: { comment: attributes_for(:invalid_comment), question_id: question }, format: :js
                          }.to_not change(Comment, :count)
      end

      it 'responds with status 200' do
        process :create, method: :post, params: { comment: attributes_for(:invalid_comment), question_id: question }, format: :js

        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET #new' do

    before { get :new, xhr: true, params: { question_id: question }, format: :js }

    it 'assigns question to @commentable' do
      expect(assigns(:commentable)).to eq(question)
    end

    it 'assigns new Comment to @comment' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'renders the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question) }
    sign_in_user

      let!(:users_comment) { create(:comment, commentable: question, user: @user) }

      it 'deletes comment from db' do
        expect { process :destroy, method: :delete, params: { id: users_comment.id }, format: :js }
            .to change(question.comments, :count).by(-1)
      end
  end
end
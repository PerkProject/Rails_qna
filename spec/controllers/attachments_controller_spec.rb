require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    let!(:user){ create(:user) }
    sign_in_user
    let!(:question) {create(:question, user: user)}
    let!(:answer){create(:answer, question: question, user: user)}
    let!(:file){ create(:attachment, attachable: answer) }

    context 'author delete you attachment' do

      it 'delete attachment in database' do
        expect do
          delete :destroy, params: { id: file }
        end.to change(Attachment, :count).by(0)
      end

      it 'redirects to back page' do
        delete :destroy, params: { id: file }
        expect(response).to render_template request.referer
      end

    end

    context 'authenticated user can not delete attachment other user' do
      before do
        sign_out(:user)
        sign_in create(:user)
      end

      it 'does not delete Attachment' do
        expect { delete :destroy, params: { id: file } }.to_not change(Attachment, :count)
      end

      it 'redirect to back path' do
        delete :destroy, params: { id: file }
        expect(response).to render_template request.referer
      end
    end
  end

end

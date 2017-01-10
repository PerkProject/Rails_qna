require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    let!(:user){ create(:user) }
    sign_in_user
    let!(:question) {create(:question, user: user)}
    let!(:answer){create(:answer, question: question, user: user)}
    let!(:file){ create(:attachment, attachable: answer) }

    context 'author delete you attachment' do

      it 'delete attachment in database', js: true do
        expect do
          delete :destroy, params: { id: file }, format: :js
        end.to change(Attachment, :count).by(0)
      end

    end

    context 'authenticated user can not delete attachment other user' do
      before do
        sign_out(:user)
        sign_in create(:user)
      end

      it 'does not delete Attachment', js: true do
        expect { delete :destroy, params: { id: file }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end

end

require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get '/api/v1/questions', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'when user authenticated' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      it 'returns collection of questions' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr} in question" do
          question = questions.first
          expect(response.body)
              .to be_json_eql(question.send(attr.to_sym).to_json)
                      .at_path("questions/0/#{attr}")
        end
      end
    end
  end
end
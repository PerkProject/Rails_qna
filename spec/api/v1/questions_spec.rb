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

  describe 'GET #show' do
    let(:question) { create :question }

    context 'when user is not authenticated' do
      it 'return status 401 if there is no access token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if there is invalid access token' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'when user authenticated' do
      let!(:access_token) { create :access_token }
      let!(:comments) { create_list(:comment, 2) }
      let!(:attachments) { create_list(:attachment, 2) }

      before do
        question.comments << comments
        question.attachments << attachments
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr} in question" do
          expect(response.body)
              .to be_json_eql(question.send(attr.to_sym).to_json)
                      .at_path("question/#{attr}")
        end
      end

      context 'comments' do
        %w(id content created_at updated_at).each do |attr|
          it "contains #{attr} in comment" do
            comment = comments.first
            expect(response.body)
                .to be_json_eql(comment.send(attr.to_sym).to_json)
                        .at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "contains url for each question attachment" do
          attachment = attachments.last
          expect(response.body)
              .to be_json_eql(attachment.file.url.to_json)
                      .at_path("question/attachments/0/url")
        end
      end
    end
  end
end
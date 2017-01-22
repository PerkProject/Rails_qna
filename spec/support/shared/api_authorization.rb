shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'returns 401 status then there is no access token' do
      send(http_method, path, {format: :json}.merge(try(:options) || {}))

      expect(response.status).to eq 401
    end

    it 'returns 401 status then access token is invalid' do
      send(http_method, path, {format: :json, access_token: '1234'}.merge(try(:options) || {}))

      expect(response.status).to eq 401
    end
  end
end
class Dinero

  def initialize(client_id: nil, client_secret: nil, api_key:, organization_id:)
    @client_id = client_id || ENV['DINERO_CLIENT_ID']
    @client_secret = client_secret || ENV['DINERO_CLIENT_SECRET']
    @api_key = api_key.strip
    @organization_id = organization_id.strip
  end

  def contacts
    response = RestClient.get "https://api.dinero.dk/v1/#{@organization_id}/contacts", { Authorization: "Bearer #{@auth_token}", accept: :json }
    JSON.parse(response)['Collection']
  end

  def create_file(file)
    Rails.logger.info "Uploading file #{file.path}"
    response = RestClient.post "https://api.dinero.dk/v1/#{@organization_id}/files", { file: file }, { Authorization: "Bearer #{@auth_token}", accept: :json }
    JSON.parse(response)['FileGuid']
  end

  def create_purchase(date: DateTime.now, file_id: nil, notes: nil)
    response = RestClient.post "https://api.dinero.dk/v1/#{@organization_id}/vouchers/purchase", { VoucherDate: date.strftime('%Y-%m-%d'), FileGuid: file_id, Notes: notes }.to_json, { Authorization: "Bearer #{@auth_token}", accept: :json, content_type: :json }
    JSON.parse(response)['VoucherGuid']
  end

  def authorize!
    @auth_token = get_token
  end

  def get_token
    auth = "#{@client_id}:#{@client_secret}"
    auth = Base64.urlsafe_encode64 auth
    params = {
      grant_type: 'password',
      scope: 'read write',
      username: @api_key,
      password: @api_key
    }

    begin
      response = RestClient.post 'https://authz.dinero.dk/dineroapi/oauth/token', params, { Authorization: "Basic #{auth}", accept: :json }
      JSON.parse(response)['access_token']
    rescue RestClient::BadRequest, RestClient::Unauthorized
      raise AuthorizationError
    end
  end

  class AuthorizationError < StandardError
  end

end

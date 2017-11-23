class Dinero

  def initialize(client_id: nil, client_secret: nil, api_key:, organization_id:)
    @client_id = client_id || ENV['DINERO_CLIENT_ID']
    @client_secret = client_secret || ENV['DINERO_CLIENT_SECRET']
    @api_key = api_key
    @organization_id = organization_id
  end

  def contacts
    request do
      response = RestClient.get "https://api.dinero.dk/v1/#{@organization_id}/contacts", { Authorization: "Bearer #{@auth_token}", accept: :json }
      JSON.parse(response)['Collection']
    end
  end

  def create_file(file)
    request do
      Rails.logger.info "Uploading file #{file.path}"
      file.rewind # ensure the file is not closed when retrying
      response = RestClient.post "https://api.dinero.dk/v1/#{@organization_id}/files", { file: file }, { Authorization: "Bearer #{@auth_token}", accept: :json }
      JSON.parse(response)['FileGuid']
    end
  end

  def create_purchase(date: DateTime.now, file_id: nil, notes: nil)
    request do
      response = RestClient.post "https://api.dinero.dk/v1/#{@organization_id}/vouchers/purchase", { VoucherDate: date.strftime('%Y-%m-%d'), FileGuid: file_id, Notes: notes }.to_json, { Authorization: "Bearer #{@auth_token}", accept: :json, content_type: :json }
      JSON.parse(response)['VoucherGuid']
    end
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
      Rails.logger.info response
      JSON.parse(response)['access_token']
    rescue RestClient::BadRequest, RestClient::Unauthorized
      raise AuthorizationError
    end
  end

  private

  def request
    begin
      with_retries(max_tries: 3) do
        Response.new(yield).successful!
      end
    rescue RestClient::BadRequest => e
      Response.new(e.message).failed!
    end
  end

  class Response < SimpleDelegator

    def successful!
      @success = true
      self
    end

    def failed!
      @success = false
      self
    end

    def success?
      @success
    end

    def failed?
      !@success
    end

  end

  class AuthorizationError < StandardError
  end

end

require 'rest-client'
require 'json'
require 'pp'

# ML Api
module ApiMercadoLivre
  # authentication service class
  class AuthenticationService < ApplicationService
    attr_accessor :seller

    def initialize(seller)
      @seller = seller
    end

    def call
      if first_access?
        # puts 'this is the first access'
        retrieve_first_access_tokens
      else
        # puts 'using the refresh token'
        auth_with_refresh_token
      end
      # puts '>>>> Seller has been authenticated <<<<'
    end

    def first_access?
      @seller.access_token.nil?
    end

    # para funcionar é necessário que o code esteja correto na base de dados
    def retrieve_first_access_tokens
      headers = { 'content-type' => 'application/x-www-form-urlencoded', 'accept' => 'application/json' }
      url = 'https://api.mercadolibre.com/oauth/token'
      payload = {
        'grant_type' => 'authorization_code',
        'client_id' => ENV['ML_API_CLIENT_ID'],
        'client_secret' => ENV['ML_API_CLIENT_SECRET'],
        'code' => 'TG-62a2beaf9c9c7a00133c1a97-140329822',
        'redirect_uri' => 'https://localhost:3000'
      }.to_json
      save_tokens(RestClient.post(url, payload, headers))
    end

    def auth_with_refresh_token
      headers = { 'content-type' => 'application/x-www-form-urlencoded', 'accept' => 'application/json' }
      url = 'https://api.mercadolibre.com/oauth/token'
      payload = {
        'grant_type' => 'refresh_token',
        'client_id' => ENV['ML_API_CLIENT_ID'],
        'client_secret' => ENV['ML_API_CLIENT_SECRET'],
        'refresh_token' => @seller.refresh_token
      }.to_json
      save_tokens(RestClient.post(url, payload, headers))
    end

    def save_tokens(response)
      parsed_response = JSON.parse(response)
      @seller.access_token = parsed_response['access_token']
      @seller.refresh_token = parsed_response['refresh_token']
      @seller.save
    end
  end
end

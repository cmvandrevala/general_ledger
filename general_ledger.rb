require 'sinatra/base'
require_relative 'lib/main/api'

class GeneralLedger < Sinatra::Base
  before do
    @api = Api.new
    request.body.rewind
    @request_payload = JSON.parse request.body.read
  end

  post '/open_account' do
    @api.open_account(@request_payload)
  end

  post '/close_account' do
    @api.close_account(@request_payload)
  end

  post '/append_snapshot' do
    @api.append_snapshot(@request_payload)
  end

  run! if app_file == $0
end

require 'sinatra/base'
require_relative 'lib/main/api'

class GeneralLedger < Sinatra::Base
  before do
    request.body.rewind
    @request_payload = JSON.parse request.body.read
  end

  post '/open_account' do
    Api.new.open_account(@request_payload)
  end

  post '/close_account' do
    Api.new.close_account(@request_payload)
  end

  post '/append_snapshot' do
    Api.new.append_snapshot(@request_payload)
  end

  run! if app_file == $0
end

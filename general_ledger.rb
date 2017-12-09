require 'sinatra/base'
require_relative 'lib/json/response_builder'

class GeneralLedger < Sinatra::Base
  before do
    request.body.rewind
    @request_payload = JSON.parse request.body.read
  end

  post '/open_account' do
    account = Account.find_by_json @request_payload
    account.update(open: true)
  end

  run! if app_file == $0
end

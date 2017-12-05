$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'db/database_connection'
require_relative 'lib/model/models'

DB = DatabaseConnection.new.create

institution = Institution.create(name: "Inst Name")
account = Account.create(name: "Account Name", owner: "Bob", institution_id: institution[:id])

before do
  request.body.rewind
  @request_payload = JSON.parse request.body.read
end

post '/open_account' do
  account = Account.find_from_json @request_payload
  account.update(open: true)
  content_type :json
  {success: true, account: account.inspect}.to_json
end

post '/close_account' do
  account = Account.find_from_json @request_payload
  account.update(open: false)
  content_type :json
  {success: true}.to_json
end

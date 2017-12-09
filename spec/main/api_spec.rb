require_relative '../../lib/main/api.rb'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

describe 'GeneralLedger' do

  before(:each) do
    @api = Api.new
  end

  context '#open_account' do

    it "opens a closed account" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: "US Bank")
        Account.create(name: "Checking", owner: "Bob Bobberson", institution_id: institution[:id], open: false)
        json = {'account' => 'Checking', 'owner' => 'Bob Bobberson', 'institution' => 'US Bank'}
        response = @api.open_account(json)
        account = Account.where(name: "Checking", owner: "Bob Bobberson").first
        expect(account[:open]).to be true
        headers = {"Content-Type" => 'application/json'}
        body = {account: {name: "Checking", owner: "Bob Bobberson", open: true}}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

    it "keeps an open account open" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: "US Bank")
        Account.create(name: "Checking", owner: "Sam Sammerson", institution_id: institution[:id], open: true)
        json = {'account' => 'Checking', 'owner' => 'Sam Sammerson', 'institution' => 'US Bank'}
        response = @api.open_account(json)
        account = Account.where(name: "Checking", owner: "Sam Sammerson").first
        expect(account[:open]).to be true
        headers = {"Content-Type" => 'application/json'}
        body = {account: {name: "Checking", owner: "Sam Sammerson", open: true}}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

    it "gracefully handles a missing account" do
      DatabaseCleaner.cleaning do
        json = {'account' => 'Checking', 'owner' => 'Sam Sammerson', 'institution' => 'US Bank'}
        response = @api.open_account(json)
        headers = {"Content-Type" => 'application/json'}
        body = {}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

  end

  context '#close_account' do

    it "closes an open account" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: "US Bank")
        Account.create(name: "Checking", owner: "Bob Bobberson", institution_id: institution[:id], open: true)
        json = {'account' => 'Checking', 'owner' => 'Bob Bobberson', 'institution' => 'US Bank'}
        response = @api.close_account(json)
        account = Account.where(name: "Checking", owner: "Bob Bobberson").first
        expect(account[:open]).to be false
        headers = {"Content-Type" => 'application/json'}
        body = {account: {name: "Checking", owner: "Bob Bobberson", open: false}}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

    it "keeps a closed account closed" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: "US Bank")
        Account.create(name: "Checking", owner: "Sam Sammerson", institution_id: institution[:id], open: false)
        json = {'account' => 'Checking', 'owner' => 'Sam Sammerson', 'institution' => 'US Bank'}
        response = @api.close_account(json)
        account = Account.where(name: "Checking", owner: "Sam Sammerson").first
        expect(account[:open]).to be false
        headers = {"Content-Type" => 'application/json'}
        body = {account: {name: "Checking", owner: "Sam Sammerson", open: false}}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

    it "gracefully handles a missing account" do
      DatabaseCleaner.cleaning do
        json = {'account' => 'Checking', 'owner' => 'Sam Sammerson', 'institution' => 'US Bank'}
        response = @api.close_account(json)
        headers = {"Content-Type" => 'application/json'}
        body = {}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

  end

end

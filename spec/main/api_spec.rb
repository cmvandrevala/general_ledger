require_relative '../../lib/main/api.rb'
require 'database_cleaner'
require 'yaml'

DatabaseCleaner.strategy = :transaction

describe 'GeneralLedger' do

  before(:each) do
    @api = Api.new
  end

  context '#open_account' do

    it "opens a closed account" do
      DatabaseCleaner.cleaning do
        institution = InstitutionAccess.create(name: "US Bank")
        AccountAccess.create(name: "Checking", owner: "Bob Bobberson", institution_id: institution[:id], open: false)
        json = {'account' => 'Checking', 'owner' => 'Bob Bobberson', 'institution' => 'US Bank'}
        response = @api.open_account(json)
        account = AccountAccess.where(name: "Checking", owner: "Bob Bobberson").first
        expect(account[:open]).to be true
        headers = {"Content-Type" => 'application/json'}
        body = {account: {name: "Checking", owner: "Bob Bobberson", open: true}}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

    it "keeps an open account open" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: "US Bank")
        AccountAccess.create(name: "Checking", owner: "Sam Sammerson", institution_id: institution[:id], open: true)
        json = {'account' => 'Checking', 'owner' => 'Sam Sammerson', 'institution' => 'US Bank'}
        response = @api.open_account(json)
        account = AccountAccess.where(name: "Checking", owner: "Sam Sammerson").first
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
        institution = InstitutionAccess.create(name: "US Bank")
        AccountAccess.create(name: "Checking", owner: "Bob Bobberson", institution_id: institution[:id], open: true)
        json = {'account' => 'Checking', 'owner' => 'Bob Bobberson', 'institution' => 'US Bank'}
        response = @api.close_account(json)
        account = AccountAccess.where(name: "Checking", owner: "Bob Bobberson").first
        expect(account[:open]).to be false
        headers = {"Content-Type" => 'application/json'}
        body = {account: {name: "Checking", owner: "Bob Bobberson", open: false}}.to_json
        expect(response).to eq [200, headers, [body]]
      end
    end

    it "keeps a closed account closed" do
      DatabaseCleaner.cleaning do
        institution = InstitutionAccess.create(name: "US Bank")
        AccountAccess.create(name: "Checking", owner: "Sam Sammerson", institution_id: institution[:id], open: false)
        json = {'account' => 'Checking', 'owner' => 'Sam Sammerson', 'institution' => 'US Bank'}
        response = @api.close_account(json)
        account = AccountAccess.where(name: "Checking", owner: "Sam Sammerson").first
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

  context "#append_snapshot" do

    it "appends a snapshot to the database with no existing information" do
      DatabaseCleaner.cleaning do
        json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => Date.new(2013,1,7)}
        response = @api.append_snapshot(json)
        institution = InstitutionAccess.first
        account = AccountAccess.first
        investment = InvestmentAccess.first
        snapshot = SnapshotAccess.first
        expect(institution[:name]).to eq 'US Bank'
        expect(account[:name]).to eq 'Checking'
        expect(investment[:name]).to eq 'Poodles and Things'
        expect(snapshot[:value]).to eq 1012
        expect(snapshot[:timestamp]).to eq Date.new(2013,1,7)
      end
    end

    it "ensures that the institution, account, investment, and snapshot all have the correct relations" do
      DatabaseCleaner.cleaning do
        json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => Date.new(2013,1,7)}
        response = @api.append_snapshot(json)
        institution = Institution.first
        account = AccountAccess.first
        investment = InvestmentAccess.first
        snapshot = Snapshot.first
        expect(account.institution).to eq institution
        expect(investment.account).to eq account
        expect(snapshot.investment).to eq investment
      end
    end

    it "appends a snapshot to the database when the institution already exists" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => Date.new(2013,1,7)}
        response = @api.append_snapshot(json)
        account = AccountAccess.first
        investment = InvestmentAccess.first
        snapshot = Snapshot.first
        expect(Institution.all.length).to eq 1
        expect(account[:name]).to eq 'Checking'
        expect(investment[:name]).to eq 'Poodles and Things'
        expect(snapshot[:value]).to eq 1012
        expect(snapshot[:timestamp]).to eq Date.new(2013,1,7)
        expect(account.institution).to eq institution
        expect(investment.account).to eq account
        expect(snapshot.investment).to eq investment
      end
    end

    it "appends a snapshot to the database when the account already exists" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = AccountAccess.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => Date.new(2013,1,7)}
        response = @api.append_snapshot(json)
        investment = InvestmentAccess.first
        snapshot = Snapshot.first
        expect(Institution.all.length).to eq 1
        expect(AccountAccess.all.length).to eq 1
        expect(investment[:name]).to eq 'Poodles and Things'
        expect(snapshot[:value]).to eq 1012
        expect(snapshot[:timestamp]).to eq Date.new(2013,1,7)
        expect(account.institution).to eq institution
        expect(investment.account).to eq account
        expect(snapshot.investment).to eq investment
      end
    end

    it "appends a snapshot to the database when the invesetment already exists" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = AccountAccess.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        investment = InvestmentAccess.create(name: 'Poodles and Things', symbol: 'PT', asset: true, account_id: account[:id])
        json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => Date.new(2013,1,7)}
        response = @api.append_snapshot(json)
        snapshot = Snapshot.first
        expect(Institution.all.length).to eq 1
        expect(AccountAccess.all.length).to eq 1
        expect(InvestmentAccess.all.length).to eq 1
        expect(snapshot[:value]).to eq 1012
        expect(snapshot[:timestamp]).to eq Date.new(2013,1,7)
        expect(account.institution).to eq institution
        expect(investment.account).to eq account
        expect(snapshot.investment).to eq investment
      end
    end

    it "returns a successful response if the snapshot has been created" do
      DatabaseCleaner.cleaning do
        json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things', 'asset' => true, 'value' => 1012, 'timestamp' => Date.new(2013,1,7)}
        response = @api.append_snapshot(json)
        expect(response).to eq [200, {"Content-Type"=>"application/json"}, [{status: "Successfully appended the snapshot"}.to_json]]
      end
    end

    it "returns a failure response if the JSON input is invalid" do
      DatabaseCleaner.cleaning do
        invalid_json = {'institution' => 'US Bank', 'account' => 'Checking', 'owner' => 'Sam Sammerson', 'investment' => 'Poodles and Things'}
        response = @api.append_snapshot(invalid_json)
        expect(response).to eq [200, {"Content-Type"=>"application/json"}, [{status: "The JSON is invalid"}.to_json]]
      end
    end

  end

end

require 'database_cleaner'
require 'model/snapshot_access'

DatabaseCleaner.strategy = :transaction

describe Snapshot do

  context '#create_snapshot_with_structure' do

    it 'creates a snapshot and its associated accounts, investments, and institutions in an empty database' do
      DatabaseCleaner.cleaning do
        json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'timestamp' => '2016-12-12', 'value' => 10123}
        actual_response = SnapshotAccess.create_snapshot_with_structure(json)
        expected_response = {status: 'Successfully appended the snapshot'}
        institution = Institution.first
        account = Account.first
        investment = Investment.first
        snapshot = Snapshot.first
        expect(snapshot.investment).to eq investment
        expect(investment.account).to eq account
        expect(account.institution).to eq institution
        expect(actual_response).to eq expected_response
      end
    end

    it 'creates a snapshot when an institution already exists' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'timestamp' => '2016-12-12', 'value' => 10123}
        actual_response = SnapshotAccess.create_snapshot_with_structure(json)
        expected_response = {status: 'Successfully appended the snapshot'}
        account = Account.first
        investment = Investment.first
        snapshot = Snapshot.first
        expect(snapshot.investment).to eq investment
        expect(investment.account).to eq account
        expect(account.institution).to eq institution
        expect(actual_response).to eq expected_response
      end
    end

    it 'creates a snapshot when an account already exists' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        account = Account.create(name: 'account', owner: 'owner', institution_id: institution[:id])
        json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'timestamp' => '2016-12-12', 'value' => 10123}
        actual_response = SnapshotAccess.create_snapshot_with_structure(json)
        expected_response = {status: 'Successfully appended the snapshot'}
        investment = Investment.first
        snapshot = Snapshot.first
        expect(snapshot.investment).to eq investment
        expect(investment.account).to eq account
        expect(account.institution).to eq institution
        expect(actual_response).to eq expected_response
      end
    end

    it 'creates a snapshot when an investment already exists' do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'institution')
        account = Account.create(name: 'account', owner: 'owner', institution_id: institution[:id])
        investment = Investment.create(name: 'investment', asset: true, account_id: account[:id])
        json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'asset' => true, 'timestamp' => '2016-12-12', 'value' => 10123}
        actual_response = SnapshotAccess.create_snapshot_with_structure(json)
        expected_response = {status: 'Successfully appended the snapshot'}
        snapshot = Snapshot.first
        expect(snapshot.investment).to eq investment
        expect(investment.account).to eq account
        expect(account.institution).to eq institution
        expect(actual_response).to eq expected_response
      end
    end

    it 'does not create any new entries in the database if the json input is invalid' do
      DatabaseCleaner.cleaning do
        invalid_json = {'institution' => 'institution', 'account' => 'account', 'owner' => 'owner', 'investment' => 'investment', 'timestamp' => '2016-12-12', 'value' => 10123}
        actual_response = SnapshotAccess.create_snapshot_with_structure(invalid_json)
        expected_response = {status: 'Failed to append the snapshot'}
        expect(Institution.first).to be nil
        expect(Account.first).to be nil
        expect(Investment.first).to be nil
        expect(Snapshot.first).to be nil
        expect(actual_response).to eq expected_response
      end
    end

  end

  context "#get_all_open_snapshots" do

    it "returns an empty response if there are no snapshots in the database" do
      DatabaseCleaner.cleaning do
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: []}
        expect(response).to eq expected_response
      end
    end

    it "returns a snapshot from the database" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = Account.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        investment = Investment.create(name: 'Investment', asset: false, asset_class: 'Cash Equivalents', account_id: account[:id], open_date: '2010-01-01')
        Snapshot.create(timestamp: '2011-12-13', value: 112233, investment_id: investment[:id])
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: [{institution: "US Bank", account: "Checking", owner: "Sam Sammerson", investment: "Investment", asset: false, asset_class: "Cash Equivalents", update_frequency: 7, value: 112233, timestamp: Date.new(2011,12,13), open_date: Date.new(2010,1,1), term: nil}]}
        expect(response).to eq expected_response
      end
    end

    it "returns a snapshot from the database with a default asset class" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = Account.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        investment = Investment.create(name: 'Investment', asset: false, account_id: account[:id])
        Snapshot.create(timestamp: '2011-12-13', value: 112233, investment_id: investment[:id])
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: [{institution: "US Bank", account: "Checking", owner: "Sam Sammerson", investment: "Investment", asset: false, asset_class: "None", update_frequency: 7, value: 112233, timestamp: Date.new(2011,12,13), open_date: nil, term: nil}]}
        expect(response).to eq expected_response
      end
    end

    it "does not return a snapshot when its account is closed" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = Account.create(name: 'Checking', owner: 'Sam Sammerson', open: false, institution_id: institution[:id])
        investment = Investment.create(name: 'Investment', asset: false, account_id: account[:id])
        Snapshot.create(timestamp: '2011-12-13', value: 112233, investment_id: investment[:id])
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: []}
        expect(response).to eq expected_response
      end
    end

    it "does not return a snapshot when its investment is closed" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = Account.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        investment = Investment.create(name: 'Investment', asset: false, open: false, account_id: account[:id])
        Snapshot.create(timestamp: '2011-12-13', value: 112233, investment_id: investment[:id])
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: []}
        expect(response).to eq expected_response
      end
    end

    it "returns an investment with a non-default update frequency" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = Account.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        investment = Investment.create(name: 'Investment', asset: false, update_frequency: 5, account_id: account[:id])
        Snapshot.create(timestamp: '2011-12-13', value: 112233, investment_id: investment[:id])
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: [{institution: "US Bank", account: "Checking", owner: "Sam Sammerson", investment: "Investment", asset: false, asset_class: "None", update_frequency: 5, value: 112233, timestamp: Date.new(2011,12,13), open_date: nil, term: nil}]}
        expect(response).to eq expected_response
      end
    end

    it "returns an investment with a term of nil" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = Account.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        investment = Investment.create(name: 'Investment', asset: false, update_frequency: 5, account_id: account[:id])
        Snapshot.create(timestamp: '2011-12-13', value: 112233, investment_id: investment[:id])
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: [{institution: "US Bank", account: "Checking", owner: "Sam Sammerson", investment: "Investment", asset: false, asset_class: "None", update_frequency: 5, value: 112233, timestamp: Date.new(2011,12,13), open_date: nil, term: nil}]}
        expect(response).to eq expected_response
      end
    end

    it "returns an investment with a term of short" do
      DatabaseCleaner.cleaning do
        institution = Institution.create(name: 'US Bank')
        account = Account.create(name: 'Checking', owner: 'Sam Sammerson', institution_id: institution[:id])
        investment = Investment.create(name: 'Investment', asset: false, update_frequency: 5, account_id: account[:id], term: "short")
        Snapshot.create(timestamp: '2011-12-13', value: 112233, investment_id: investment[:id])
        response = SnapshotAccess.get_all_open_snapshots
        expected_response = {snapshots: [{institution: "US Bank", account: "Checking", owner: "Sam Sammerson", investment: "Investment", asset: false, asset_class: "None", update_frequency: 5, value: 112233, timestamp: Date.new(2011,12,13), open_date: nil, term: "short"}]}
        expect(response).to eq expected_response
      end
    end

  end

end

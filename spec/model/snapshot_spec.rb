require 'database_cleaner'
require 'model/model'

DatabaseCleaner.strategy = :transaction

describe Snapshot do

  it 'creates a new snapshot' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10_000, description: 'Debit')
      expect(Snapshot.all.length).to eq 1
    end
  end

  it 'creates two new snapshots' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10, description: 'Debit')
      Snapshot.create(timestamp: DateTime.now, value: 10_000)
      expect(Snapshot.all.length).to eq 2
    end
  end

  it 'sets the timestamp of the snapshot' do
    DatabaseCleaner.cleaning do
      timestamp = DateTime.now
      Snapshot.create(timestamp: timestamp, value: 10, description: 'Debit')
      snapshot = Snapshot.all.first
      expect(snapshot[:timestamp].to_date).to eq timestamp.to_date
    end
  end

  it 'enforces a non-null timestamp for the snapshot' do
    DatabaseCleaner.cleaning do
      expect{ Snapshot.create(value: 10, description: 'Debit') }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the value of the snapshot' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10, description: 'Debit')
      snapshot = Snapshot.all.first
      expect(snapshot[:value]).to eq 10
    end
  end

  it 'enforces a non-null value for the snapshot' do
    DatabaseCleaner.cleaning do
      expect{ Snapshot.create(timestamp: DateTime.now, description: 'Debit') }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the description for the snapshot' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10, description: 'Debit')
      snapshot = Snapshot.all.first
      expect(snapshot[:description]).to eq 'Debit'
    end
  end

  it 'sets null for the description for the snapshot' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10)
      snapshot = Snapshot.all.first
      expect(snapshot[:description]).to be_nil
    end
  end

  it 'sets the created_at timestamp' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10_000, description: 'Debit')
      snapshot = Snapshot.all.first
      expect(snapshot[:created_at]).not_to be_nil
    end
  end

  it 'sets the updated_at timestamp at creation' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10_000, description: 'Debit')
      snapshot = Snapshot.all.first
      expect(snapshot[:updated_at]).not_to be_nil
    end
  end

  it 'sets the id of the snapshot' do
    DatabaseCleaner.cleaning do
      Snapshot.create(timestamp: DateTime.now, value: 10_000, description: 'Debit')
      snapshot = Snapshot.all.first
      expect(snapshot[:id]).not_to be_nil
    end
  end

  it 'has an investment as a parent' do
    DatabaseCleaner.cleaning do
      institution = Institution.create(name: 'inst')
      account = Account.create(name: 'Account Name', owner: 'Bob', institution_id: institution[:id])
      investment = Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: true, account_id: account[:id])
      snapshot = Snapshot.create(timestamp: DateTime.now, value: 10_000, description: 'Debit', investment_id: investment[:id])
      expect(snapshot[:investment_id]).to eq investment[:id]
      expect(investment.snapshots).to eq [snapshot]
      expect(snapshot.investment).to eq investment
    end
  end

end

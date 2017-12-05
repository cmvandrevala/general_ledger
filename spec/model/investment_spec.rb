require 'database_cleaner'
require 'model/investment'

DatabaseCleaner.strategy = :transaction

describe Investment do

  it 'creates a new investment' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'ABC', asset: true)
      expect(Investment.all.length).to eq 1
    end
  end

  it 'creates two new investments' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name 1', symbol: 'CASHX', asset: true)
      Investment.create(name: 'Investment Name 2', symbol: 'PG', asset: false)
      expect(Investment.all.length).to eq 2
    end
  end

  it 'sets the name of the investment' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: true)
      investment = Investment.all.first
      expect(investment[:name]).to eq 'Investment Name'
    end
  end

  it 'enforces a non-null name for the investment' do
    DatabaseCleaner.cleaning do
      expect{ Investment.create(symbol: 'CASHX', asset: true) }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the symbol of the investment' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false)
      investment = Investment.all.first
      expect(investment[:symbol]).to eq 'CASHX'
    end
  end

  it 'enforces a non-null owner for the investment' do
    DatabaseCleaner.cleaning do
      expect{ Investment.create(name: 'Investment Name', asset: true) }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the asset of the investment to true' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: true)
      investment = Investment.all.first
      expect(investment[:asset]).to eq true
    end
  end

  it 'sets the asset of the investment to false' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false)
      investment = Investment.all.first
      expect(investment[:asset]).to eq false
    end
  end

  it 'enforces a non-null asset for the investment' do
    DatabaseCleaner.cleaning do
      expect{ Investment.create(name: 'Investment Name', symbol: 'CASHX') }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the created_at timestamp' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name 1', symbol: 'CASHX', asset: false)
      investment = Investment.all.first
      expect(investment[:created_at]).not_to be_nil
    end
  end

  it 'sets the updated_at timestamp at creation' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name 1', symbol: 'CASHX', asset: true)
      investment = Investment.all.first
      expect(investment[:updated_at]).not_to be_nil
    end
  end

  it 'sets the id of the investment' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name 1', symbol: 'CASHX', asset: true)
      investment = Investment.all.first
      expect(investment[:id]).not_to be_nil
    end
  end

  it 'has an account as a parent' do
    DatabaseCleaner.cleaning do
      institution = Institution.create(name: 'inst')
      account = Account.create(name: 'Investment Name 1', owner: 'Bob', institution_id: institution[:id])
      investment = Investment.create(name: 'Investment Name 1', symbol: 'CASHX', asset: true, account_id: account[:id])
      expect(investment[:account_id]).to eq account[:id]
      expect(account.investments).to eq [investment]
      expect(investment.account).to eq account
    end
  end

end

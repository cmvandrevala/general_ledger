require 'database_cleaner'
require 'model/investment'

DatabaseCleaner.strategy = :transaction

describe Investment do

  it 'creates a new investment' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'ABC', asset: true, term: 'short')
      expect(Investment.all.length).to eq 1
    end
  end

  it 'creates two new investments' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name 1', symbol: 'CASHX', asset: true, term: 'short')
      Investment.create(name: 'Investment Name 2', symbol: 'PG', asset: false, term: 'short')
      expect(Investment.all.length).to eq 2
    end
  end

  it 'sets the name of the investment' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: true, term: 'short')
      investment = Investment.all.first
      expect(investment[:name]).to eq 'Investment Name'
    end
  end

  it 'enforces a non-null name for the investment' do
    DatabaseCleaner.cleaning do
      expect{ Investment.create(symbol: 'CASHX', asset: true, term: 'short') }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the symbol of the investment' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, term: 'short')
      investment = Investment.all.first
      expect(investment[:symbol]).to eq 'CASHX'
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

  it 'sets the term of the investment to short' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, term: 'short')
      investment = Investment.all.first
      expect(investment[:term]).to eq 'short'
    end
  end

  it 'sets the term of the investment to medium' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, term: 'medium')
      investment = Investment.all.first
      expect(investment[:term]).to eq 'medium'
    end
  end

  it 'sets the term of the investment to long' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, term: 'long')
      investment = Investment.all.first
      expect(investment[:term]).to eq 'long'
    end
  end

  it 'does not set an invesetment term with a random value' do
    DatabaseCleaner.cleaning do
      expect{Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, term: 'foobar')}.to raise_error Sequel::CheckConstraintViolation
    end
  end

  it 'sets the date an investment was opened' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, open_date: Date.new(2001,2,3))
      investment = Investment.all.first
      expect(investment[:open_date]).to eq Date.new(2001,2,3)
    end
  end

  it 'sets the date an investment was closed' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, close_date: Date.new(2012,2,3))
      investment = Investment.all.first
      expect(investment[:close_date]).to eq Date.new(2012,2,3)
    end
  end

  it 'sets both an open and close date' do
    DatabaseCleaner.cleaning do
      Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, open_date: Date.new(2010,1,1), close_date: Date.new(2012,2,3))
      investment = Investment.all.first
      expect(investment[:open_date]).to eq Date.new(2010,1,1)
      expect(investment[:close_date]).to eq Date.new(2012,2,3)
    end
  end

  it 'the close date cannot occur before the open date' do
    DatabaseCleaner.cleaning do
      expect{Investment.create(name: 'Investment Name', symbol: 'CASHX', asset: false, open_date: Date.new(2012,2,8), close_date: Date.new(2012,2,3))}.to raise_error Sequel::CheckConstraintViolation
    end
  end

  it 'enforces a non-null asset for the investment' do
    DatabaseCleaner.cleaning do
      expect{ Investment.create(name: 'Investment Name', symbol: 'CASHX', term: 'short') }.to raise_error Sequel::NotNullConstraintViolation
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

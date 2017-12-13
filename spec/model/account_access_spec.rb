require 'database_cleaner'
require 'model/account_access'

DatabaseCleaner.strategy = :transaction

describe AccountAccess do

  it 'creates a new account' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name', owner: 'Bob')
      expect(AccountAccess.all.length).to eq 1
    end
  end

  it 'creates two new accounts' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name 1', owner: 'Bob')
      AccountAccess.create(name: 'Account Name 2', owner: 'Sam')
      expect(AccountAccess.all.length).to eq 2
    end
  end

  it 'sets the name of the account' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name', owner: 'Bob')
      account = AccountAccess.first
      expect(account[:name]).to eq 'Account Name'
    end
  end

  it 'enforces a non-null name for the account' do
    DatabaseCleaner.cleaning do
      expect{ AccountAccess.create(owner: 'Bob') }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the owner of the account' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name', owner: 'Bob')
      account = AccountAccess.first
      expect(account[:owner]).to eq 'Bob'
    end
  end

  it 'enforces a non-null owner for the account' do
    DatabaseCleaner.cleaning do
      expect{ AccountAccess.create(name: 'Account Name') }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it 'sets the date an account was opened' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name', owner: 'Sam Sammerson', open_date: Date.new(2001,2,3))
      account = AccountAccess.first
      expect(account[:open_date]).to eq Date.new(2001,2,3)
    end
  end

  it 'sets the date an account was closed' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name', owner: 'Sam Sammerson', close_date: Date.new(2012,2,3))
      account = AccountAccess.first
      expect(account[:close_date]).to eq Date.new(2012,2,3)
    end
  end

  it 'sets both an open and close date' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name', owner: 'Sam Sammerson', open_date: Date.new(2010,1,1), close_date: Date.new(2012,2,3))
      account = AccountAccess.first
      expect(account[:open_date]).to eq Date.new(2010,1,1)
      expect(account[:close_date]).to eq Date.new(2012,2,3)
    end
  end

  it 'the close date cannot occur before the open date' do
    DatabaseCleaner.cleaning do
      expect{AccountAccess.create(name: 'Account Name', owner: 'Sam Sammerson', open_date: Date.new(2012,2,8), close_date: Date.new(2012,2,3))}.to raise_error Sequel::CheckConstraintViolation
    end
  end

  it 'sets the created_at timestamp' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name 1', owner: 'Bob')
      account = AccountAccess.first
      expect(account[:created_at]).not_to be_nil
    end
  end

  it 'sets the updated_at timestamp at creation' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name 1', owner: 'Bob')
      account = AccountAccess.first
      expect(account[:updated_at]).not_to be_nil
    end
  end

  it 'sets the id of the account' do
    DatabaseCleaner.cleaning do
      AccountAccess.create(name: 'Account Name 1', owner: 'Bob')
      account = AccountAccess.first
      expect(account[:id]).not_to be_nil
    end
  end

  it 'has an institution as a parent' do
    DatabaseCleaner.cleaning do
      institution = InstitutionAccess.create(name: 'inst')
      account = AccountAccess.create(name: 'Account Name 1', owner: 'Bob', institution_id: institution[:id])
      expect(account[:institution_id]).to eq institution[:id]
      expect(institution.accounts).to eq [account]
      expect(account.institution).to eq institution
    end
  end

  it 'has a default value of true for the open column' do
    DatabaseCleaner.cleaning do
      institution = InstitutionAccess.create(name: 'inst')
      account = AccountAccess.create(name: 'Account Name', owner: 'Bob', institution_id: institution[:id])
      expect(account[:open]).to be true
    end
  end

  it 'can set the open column to false' do
    DatabaseCleaner.cleaning do
      institution = InstitutionAccess.create(name: 'inst')
      account = AccountAccess.create(name: 'Account Name', owner: 'Bob', open: false, institution_id: institution[:id])
      expect(account[:open]).to be false
    end
  end

  context "#find_from_json" do

    it 'finds an account given parameters via JSON' do
      DatabaseCleaner.cleaning do
        institution = InstitutionAccess.create(name: 'inst')
        AccountAccess.create(name: 'Account Name', owner: 'Bob', institution_id: institution[:id])
        json = {'account' => 'Account Name', 'owner' => 'Bob', 'institution' => 'inst'}
        account = AccountAccess.find_from_json(json)
        expect(account[:name]).to eq 'Account Name'
        expect(account.institution).to eq institution
      end
    end

    it 'returns nil if it cannot find the corresponding institution' do
      DatabaseCleaner.cleaning do
        institution = InstitutionAccess.create(name: 'inst')
        AccountAccess.create(name: 'Account Name', owner: 'Bob', institution_id: institution[:id])
        json = {'account' => 'Account Name', 'owner' => 'Bob', 'institution' => 'random'}
        account = AccountAccess.find_from_json(json)
        expect(account).to be_nil
      end
    end

    it 'returns nil if it cannot find the corresponding account name' do
      DatabaseCleaner.cleaning do
        institution = InstitutionAccess.create(name: 'inst')
        AccountAccess.create(name: 'Account Name', owner: 'Bob', institution_id: institution[:id])
        json = {'account' => 'random name', 'owner' => 'Bob', 'institution' => 'inst'}
        account = AccountAccess.find_from_json(json)
        expect(account).to be_nil
      end
    end

    it 'returns nil if it cannot find the corresponding owner' do
      DatabaseCleaner.cleaning do
        institution = InstitutionAccess.create(name: 'inst')
        AccountAccess.create(name: 'Account Name', owner: 'Bob', institution_id: institution[:id])
        json = {'account' => 'Account Name', 'owner' => 'random', 'institution' => 'inst'}
        account = AccountAccess.find_from_json(json)
        expect(account).to be_nil
      end
    end

  end

end

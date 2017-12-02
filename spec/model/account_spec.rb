require "database_cleaner"
require "model/models"

DatabaseCleaner.strategy = :transaction

describe Account do

  it "creates a new account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name", owner: "Bob", symbol: "CASHX")
      expect(Account.all.length).to eq 1
    end
  end

  it "creates two new accounts" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob", symbol: "CASHX")
      Account.create(name: "Account Name 2", owner: "Sam", symbol: "VBA")
      expect(Account.all.length).to eq 2
    end
  end

  it "sets the name of the account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name", owner: "Bob", symbol: "CASHX")
      account = Account.all.first
      expect(account[:name]).to eq "Account Name"
    end
  end

  it "enforces a non-null name for the account" do
    DatabaseCleaner.cleaning do
      expect{ Account.create(owner: "Bob", symbol: "CASHX") }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it "sets the owner of the account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name", owner: "Bob", symbol: "CASHX")
      account = Account.all.first
      expect(account[:owner]).to eq "Bob"
    end
  end

  it "enforces a non-null owner for the account" do
    DatabaseCleaner.cleaning do
      expect{ Account.create(name: "Account Name", symbol: "CASHX") }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it "sets the symbol for the account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name", owner: "Bob", symbol: "CASHX")
      account = Account.all.first
      expect(account[:symbol]).to eq "CASHX"
    end
  end

  it "enforces a non-null symbol for the account" do
    DatabaseCleaner.cleaning do
      expect{ Account.create(name: "Account Name", owner: "Bob") }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it "sets the created_at timestamp" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob", symbol: "CASHX")
      account = Account.all.first
      expect(account[:created_at]).not_to be_nil
    end
  end

  it "sets the updated_at timestamp at creation" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob", symbol: "CASHX")
      account = Account.all.first
      expect(account[:updated_at]).not_to be_nil
    end
  end

  it "sets the id of the account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob", symbol: "CASHX")
      account = Account.all.first
      expect(account[:id]).not_to be_nil
    end
  end

  it "has an institution as a parent" do
    DatabaseCleaner.cleaning do
      institution = Institution.create(name: "inst")
      account = Account.create(name: "Account Name 1", owner: "Bob", symbol: "CASHX", institution_id: institution[:id])
      expect(account[:institution_id]).to eq institution[:id]
      expect(institution.accounts).to eq [account]
      expect(account.institution).to eq institution
    end
  end

end

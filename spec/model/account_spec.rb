require "database_cleaner"
require "model/account"

DatabaseCleaner.strategy = :transaction

describe Account do

  it "creates a new account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name", owner: "Bob")
      expect(Account.all.length).to eq 1
    end
  end

  it "creates two new accounts" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob")
      Account.create(name: "Account Name 2", owner: "Sam")
      expect(Account.all.length).to eq 2
    end
  end

  it "sets the name of the account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name", owner: "Bob")
      account = Account.all.first
      expect(account[:name]).to eq "Account Name"
    end
  end

  it "enforces a non-null name for the account" do
    DatabaseCleaner.cleaning do
      expect{ Account.create(owner: "Bob") }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it "sets the owner of the account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name", owner: "Bob")
      account = Account.all.first
      expect(account[:owner]).to eq "Bob"
    end
  end

  it "enforces a non-null owner for the account" do
    DatabaseCleaner.cleaning do
      expect{ Account.create(name: "Account Name") }.to raise_error Sequel::NotNullConstraintViolation
    end
  end

  it "sets the created_at timestamp" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob")
      account = Account.all.first
      expect(account[:created_at]).not_to be_nil
    end
  end

  it "sets the updated_at timestamp at creation" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob")
      account = Account.all.first
      expect(account[:updated_at]).not_to be_nil
    end
  end

  it "sets the id of the account" do
    DatabaseCleaner.cleaning do
      Account.create(name: "Account Name 1", owner: "Bob")
      account = Account.all.first
      expect(account[:id]).not_to be_nil
    end
  end

  it "has an institution as a parent" do
    DatabaseCleaner.cleaning do
      institution = Institution.create(name: "inst")
      account = Account.create(name: "Account Name 1", owner: "Bob", institution_id: institution[:id])
      expect(account[:institution_id]).to eq institution[:id]
      expect(institution.accounts).to eq [account]
      expect(account.institution).to eq institution
    end
  end

  it "has a default value of true for the open column" do
    DatabaseCleaner.cleaning do
      institution = Institution.create(name: "inst")
      account = Account.create(name: "Account Name", owner: "Bob", institution_id: institution[:id])
      expect(account[:open]).to be true
    end
  end

  it "can set the open column to false" do
    DatabaseCleaner.cleaning do
      institution = Institution.create(name: "inst")
      account = Account.create(name: "Account Name", owner: "Bob", open: false, institution_id: institution[:id])
      expect(account[:open]).to be false
    end
  end

  it "finds an account given parameters via JSON" do
    DatabaseCleaner.cleaning do
      institution = Institution.create(name: "inst")
      Account.create(name: "Account Name", owner: "Bob", institution_id: institution[:id])
      json = {"name" => "Account Name", "owner" => "Bob", "institution" => "inst"}
      account = Account.find_from_json(json)
      expect(account[:name]).to eq "Account Name"
      expect(account.institution).to eq institution
    end
  end

end

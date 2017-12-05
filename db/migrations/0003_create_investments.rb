Sequel.migration do
  change do
    create_table(:investments) do
      primary_key :id
      foreign_key :account_id, :accounts
      DateTime :created_at
      DateTime :updated_at
      String :name, null: false
      String :symbol, null: false
      TrueClass :asset, null: false
    end
  end
end

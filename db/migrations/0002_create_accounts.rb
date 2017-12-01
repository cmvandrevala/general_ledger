Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      foreign_key :institution_id, :institutions
      DateTime :created_at
      DateTime :updated_at
      String :name, null: false
      String :owner, null: false
      String :symbol, null: false
    end
  end
end

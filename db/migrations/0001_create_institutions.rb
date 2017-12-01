Sequel.migration do
  change do
    create_table(:institutions) do
      primary_key :id
      DateTime :created_at
      DateTime :updated_at
      String :name, null: false, unique: true
    end
  end
end

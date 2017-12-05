Sequel.migration do
  change do
    create_table(:snapshots) do
      primary_key :id
      foreign_key :investment_id, :investments
      DateTime :created_at
      DateTime :updated_at
      DateTime :timestamp, null: false
      Integer :value, null: false
      String :description
    end
  end
end

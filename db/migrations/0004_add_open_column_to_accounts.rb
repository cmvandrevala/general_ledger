Sequel.migration do
  change do
    alter_table(:accounts) do
      add_column :open, TrueClass, default: true
    end
  end
end

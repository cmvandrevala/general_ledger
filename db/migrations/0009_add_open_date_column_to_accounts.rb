Sequel.migration do
  change do
    add_column :accounts, :open_date, Date
  end
end

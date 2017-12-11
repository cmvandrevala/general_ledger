Sequel.migration do
  change do
    add_column :accounts, :close_date, Date
  end
end

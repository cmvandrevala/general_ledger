Sequel.migration do
  change do
    add_column :investments, :open_date, Date
  end
end

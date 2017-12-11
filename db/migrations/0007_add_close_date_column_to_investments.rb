Sequel.migration do
  change do
    add_column :investments, :close_date, Date
  end
end

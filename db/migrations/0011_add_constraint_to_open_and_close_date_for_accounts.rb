Sequel.migration do
  up do
    alter_table(:accounts) do
      add_constraint(:open_vs_close_date_for_accounts) { open_date < close_date }
    end
  end

  down do
    alter_table(:accounts) do
      drop_constraint(:open_vs_close_date_for_accounts)
    end
  end
end

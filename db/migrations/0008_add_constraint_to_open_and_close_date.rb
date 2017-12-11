Sequel.migration do
  up do
    alter_table(:investments) do
      add_constraint(:open_vs_close_date) { open_date < close_date }
    end
  end

  down do
    alter_table(:investments) do
      drop_constraint(:open_vs_close_date)
    end
  end
end

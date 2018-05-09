class EditCatsTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :cats, :sex
    add_column :cats, :sex, :string, :limit => 1, null: false
  end
end

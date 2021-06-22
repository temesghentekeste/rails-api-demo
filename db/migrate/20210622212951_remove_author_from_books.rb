class RemoveAuthorFromBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :author, :string
  end
end

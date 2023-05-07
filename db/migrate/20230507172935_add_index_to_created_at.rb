class AddIndexToCreatedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :projects, :created_at
    add_index :comments, :created_at
    add_index :project_histories, :created_at
  end
end

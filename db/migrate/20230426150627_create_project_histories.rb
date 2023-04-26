# frozen_string_literal: true

class CreateProjectHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :project_histories do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :history_type, null: false
      t.text :description, null: false
      t.timestamps
    end
  end
end

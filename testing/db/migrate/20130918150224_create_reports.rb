class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :description, :null => false

      t.timestamps
    end
  end
end

class CreateTcbos < ActiveRecord::Migration
  def change
    create_table :tcbos do |t|
      t.string :codigo_cbo, :null => false
      t.string :descricao, :null => false

      t.timestamps
    end
  end
end

class CreateTmibges < ActiveRecord::Migration
  def change
    create_table :tmibges do |t|
      t.string :codigo_ibge, :null => false
      t.string :nome_municipio, :null => false
      t.references :tufibge, :null => false

      t.timestamps
    end
    add_index :tmibges, :tufibge_id
  end
end

class CreateTufibges < ActiveRecord::Migration
  def change
    create_table :tufibges do |t|
      t.string :sigla_uf, :null => false, :limit => 2
      t.string :codigo_ibge, :null => false
      t.string :nome_uf, :null => false

      t.timestamps
    end
  end
end

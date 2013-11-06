class CreateOrgaos < ActiveRecord::Migration
  def change
    create_table :orgaos do |t|
      t.string :nome, :null => false
      t.string :cep, :limit => 10
      t.string :bairro, :null => false
      t.string :endereco, :null => false
      t.integer :numero_endereco, :null => false
      t.string :complemento_endereco
      t.string :telefone1, :limit => 13
      t.string :telefone2, :limit => 13
      t.string :email
      t.string :url
      t.boolean :ativo, :null => false, :default => true
      t.references :tufibge, :null => false
      t.references :tmibge, :null => false
      t.references :prefeitura, :null => false

      t.timestamps
    end
    add_index :orgaos, :tufibge_id
    add_index :orgaos, :tmibge_id
    add_index :orgaos, :prefeitura_id
  end
end

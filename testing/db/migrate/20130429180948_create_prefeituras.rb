class CreatePrefeituras < ActiveRecord::Migration
  def change
    create_table :prefeituras do |t|
      t.string :nome, :null => false
      t.string :cep, :limit => 10, :null => false
      t.string :bairro, :null => false
      t.string :endereco, :null => false
      t.integer :numero_endereco, :null => false
      t.string :complemento_endereco
      t.string :telefone1, :limit => 13
      t.string :telefone2, :limit => 13
      t.string :email
      t.string :logo
      t.integer :limite_cancelamento, :null => false, :default => 48
      t.integer :max_agendamentos, :null => false, :default => 3
      t.integer :dias_bloqueio, :null => false, :default => 30
      t.references :tufibge, :null => false
      t.references :tmibge, :null => false

      t.timestamps
    end
    add_index :prefeituras, :tufibge_id
    add_index :prefeituras, :tmibge_id
  end
end

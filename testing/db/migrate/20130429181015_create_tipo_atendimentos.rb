class CreateTipoAtendimentos < ActiveRecord::Migration
  def change
    create_table :tipo_atendimentos do |t|
      t.string :descricao, :null => false
      t.boolean :ativo, :null => false, :default => true

      t.timestamps
    end
  end
end

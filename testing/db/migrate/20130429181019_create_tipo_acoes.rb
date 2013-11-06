class CreateTipoAcoes < ActiveRecord::Migration
  def change
    create_table :tipo_acoes do |t|
      t.string :descricao

      t.timestamps
    end
  end
end

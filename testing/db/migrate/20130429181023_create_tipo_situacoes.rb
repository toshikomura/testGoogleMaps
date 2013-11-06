class CreateTipoSituacoes < ActiveRecord::Migration
  def change
    create_table :tipo_situacoes do |t|
      t.string :descricao

      t.timestamps
    end
  end
end

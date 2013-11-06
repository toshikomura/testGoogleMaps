class CreateTconselhos < ActiveRecord::Migration
  def change
    create_table :tconselhos do |t|
      t.string :sigla_conselho, :null => false
      t.string :descricao, :null => false

      t.timestamps
    end
  end
end

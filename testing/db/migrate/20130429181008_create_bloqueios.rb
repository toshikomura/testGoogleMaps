class CreateBloqueios < ActiveRecord::Migration
  def change
    create_table :bloqueios do |t|
      t.date :data_entrada
      t.date :data_expira
      t.references :cidadao

      t.timestamps
    end
    add_index :bloqueios, :cidadao_id
  end
end

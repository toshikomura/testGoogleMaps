class AddParamConfigPrefeituras < ActiveRecord::Migration
  def change
    change_table :prefeituras do |t|
      t.integer :max_faltas, :null => false, :default => 1
      t.integer :periodo_agendamentos, :null => false, :default => 90
      t.integer :antecedencia_avisos, :null => false, :default => 48
    end
  end
end

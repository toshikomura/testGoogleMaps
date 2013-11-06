class CreateAgendamentos < ActiveRecord::Migration
  def change
    create_table :agendamentos do |t|
      t.datetime :horario_inicio_consulta
      t.datetime :horario_fim_consulta
      t.references :tipo_situacao
      t.references :escala
      t.references :cidadao
      t.references :orgao

      t.timestamps
    end
    add_index :agendamentos, :tipo_situacao_id
    add_index :agendamentos, :escala_id
    add_index :agendamentos, :cidadao_id
    add_index :agendamentos, :orgao_id
  end
end

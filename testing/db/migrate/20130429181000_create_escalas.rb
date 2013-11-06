class CreateEscalas < ActiveRecord::Migration
  def change
    create_table :escalas do |t|
      t.integer :numero_sequencia, :null => false
      t.date :data_execucao, :null => false
      t.time :horario_inicio_execucao, :null => false
      t.time :horario_fim_execucao, :null => false
      t.text :observacoes
      t.integer :numero_atendimentos, :null => false, :default => 0
      t.integer :profissional_executor_id
      t.integer :profissional_responsavel_id, :null => false
      t.references :tipo_atendimento, :null => false
      t.references :orgao, :null => false
      t.references :tipo_acao, :null => false

      t.timestamps
    end
    add_index :escalas, :tipo_atendimento_id
    add_index :escalas, :orgao_id
    add_index :escalas, :tipo_acao_id
  end
end

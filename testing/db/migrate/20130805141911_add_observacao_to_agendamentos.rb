class AddObservacaoToAgendamentos < ActiveRecord::Migration
  def change
    change_table :agendamentos do |t|
      t.string :observacao, limit: 255
    end
  end
end

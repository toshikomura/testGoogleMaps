class CreateOrgaoTipoAtendimentoJoinTable < ActiveRecord::Migration
  def change
    create_table :orgaos_tipo_atendimentos, :id => false do |t|
      t.integer :orgao_id, :null => false
      t.integer :tipo_atendimento_id, :null => false
    end
  end
end

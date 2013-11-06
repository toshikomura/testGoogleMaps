class DeviseCreateProfissionais < ActiveRecord::Migration
  def change
    create_table(:profissionais) do |t|
      ## Database authenticatable
      #t.string :email,              :null => false, :default => ""
      t.string :cpf,                :null => false, :limit => 14,  :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      #t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token

      t.string :nome,                    :null => false
      t.date :data_nascimento,           :null => false
      t.string :rg,                      :null => false
      t.string :emissao_rg,              :null => false
      t.string :matricula
      t.string :cep, :limit => 10
      t.string :bairro
      t.string :endereco
      t.integer :numero_endereco
      t.string :complemento_endereco
      t.string :telefone1,               :limit => 13
      t.string :telefone2,               :limit => 13
      t.string :email
      t.boolean :ativo, :null => false, :default => true
      t.references :tufibge
      t.references :tmibge
      t.references :tcbo,                :null => false
      t.references :tconselho
      t.references :orgao,               :null => false
      t.string :role,                    :null => false

      t.timestamps
    end

    add_index :profissionais, :cpf,                  :unique => true
    #add_index :profissionais, :email,                :unique => true
    add_index :profissionais, :reset_password_token, :unique => true
    # add_index :profissionais, :confirmation_token,   :unique => true
    # add_index :profissionais, :unlock_token,         :unique => true
    # add_index :profissionais, :authentication_token, :unique => true
  end
end

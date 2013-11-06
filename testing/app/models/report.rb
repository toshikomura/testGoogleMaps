class Report < ActiveRecord::Base

  ##############################
  # Relationships              #
  ##############################
  has_many :cidadaos
  has_many :profissionais
  has_many :agendamentos
  has_many :escalas
  has_many :orgaos
  belongs_to :prefeituras

  attr_accessible :description
end

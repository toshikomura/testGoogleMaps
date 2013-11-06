# encoding: UTF-8
class Cidadaos::SessionsController < Devise::SessionsController
  before_filter :sessao_profissional, :only => [:new, :create]
 
  # Verifica se uma sessão de profissional já existe.
  # @note redireciona para a página principal com uma mensagem de
  #     alerta(+alert+).
  def sessao_profissional
    if profissional_signed_in?
      redirect_to root_url,
      alert: "Você já está logado."
    end 
  end
end

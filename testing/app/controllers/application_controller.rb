# encoding: UTF-8
# = Callbacks
# == rescue_from
# - CanCan::AcessDenied, 
#   trata a execção gerada pela falha na autorização do CanCan
#   ver referência
#   {https://github.com/ryanb/cancan/wiki/exception-handling},
#   redireciona para +root_url+ mostrando a mensagem de erro no id +alert+.
#
# == before_filter
# - {#set_cache_buster}
#
class ApplicationController < ActionController::Base
  ##############################
  # Callbacks                  #
  ##############################
  protect_from_forgery

  before_filter :set_cache_buster

  # Trata a execção gerada pela falha na autorização do CanCan
  # ver referência {https://github.com/ryanb/cancan/wiki/exception-handling}
  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_url, :alert => e.message
  end

  ##############################
  # Métodos                    #
  ##############################

  # Indica que as páginas não devem ser armazenadas no cache do browser,
  # caso contrário pode gerar inconsistência ao sair(logout) e voltar a uma
  # página que está no cache.
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end

  # Define a autorização do profissional corrente.
  # @return [ProfissionalAbility Object] @current_ability retorna a
  #     autorização do profissional corrente
  # @note usa a função do #current_profissional, ver
  #     {https://github.com/plataformatec/devise#controller-filters-and-helpers
  #     Devise#current_user}
  def current_ability
    @current_ability ||= ProfissionalAbility.new(current_profissional)
  end
end

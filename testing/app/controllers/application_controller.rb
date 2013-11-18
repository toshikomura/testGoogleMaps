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
  before_filter :definir_contraste
  before_filter :definir_tamanho_fonte
  before_filter :definir_logos_prefeitura

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

  # Define o stylesheet das páginas, alto contraste ou não.
  # @note Seta a variável @contraste com a classe "alto-contraste" se o
  #   parâmetro :alto_contraste é "true", caso contrário nil, a variável é
  #   visível em todas as views do aplicativo.
  def definir_contraste
    cookie_name = "_agendador_alto_contraste".to_sym
    if(params[:alto_contraste] == "true")
      cookies[cookie_name] = "true"
    elsif(params[:alto_contraste] == "false")
      cookies[cookie_name] = "false"
    end

    if(cookies[cookie_name] == "true")
      @contraste = 'alto-contraste'
    elsif(cookies[cookie_name] == "false")
      @contraste = nil
    end
  end

  # Define o tamanho da fonte.
  # @note Seta a variável @tamanho_fonte_class com a classe "fonteX", onde X
  #   é o tamanho da fonte se o parâmetro :tamanho_fonte possui um valor
  #   válido, entre 12 e 20, caso contrário nil, também seta a variável
  #   @tamanho_fonte com o tamanho da fonte do parâmetro :tamanho_fonte,
  #    a variável são visíveis em todas as views do aplicativo.
  def definir_tamanho_fonte
    cookie_name = "_agendador_tamanho_fonte".to_sym
    min = 12
    max = 20
    if(params[:tamanho_fonte].to_i >= min &&
       params[:tamanho_fonte].to_i <= max)
      cookies[cookie_name] = params[:tamanho_fonte].to_i
    end
    if(cookies[cookie_name].to_i >= min &&
       cookies[cookie_name].to_i <= max)
      @tamanho_fonte = cookies[cookie_name].to_i
      @tamanho_fonte_class = 'fonte' + @tamanho_fonte.to_s
    else
      @tamanho_fonte = 16
      @tamanho_fonte_class = nil
    end
  end

  # Define os logos da prefeitura.
  # @note Se a prefeitura não estiver cadastrada, ou o logo for nulo, a
  #     imagem padrão void.png é indicada.
  def definir_logos_prefeitura
    logo_void = "void.png"
    prefeitura = Prefeitura.first
    if prefeitura.nil?
      @logo_prefeitura = logo_void
      @logo_contraste_prefeitura = logo_void
    else
      if prefeitura.logo.nil?
        @logo_prefeitura = logo_void
        @logo_contraste_prefeitura = logo_void
      else
        @logo_prefeitura = prefeitura.logo.to_s
        @logo_contraste_prefeitura = prefeitura.logo.to_s
      end
    end
  end
end

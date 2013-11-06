# encoding: UTF-8
class Profissionais::SessionsController < Devise::SessionsController
  before_filter :sessao_cidadao, :only => [:new, :create]
 
  # Overried sessions_create for "Profissionais" model
  # check if "profissional" is active with "ativo" attribute
  # other solution would be add in models/profissional.rb:
  # def self.find_for_authentication(conditions)
  #   super(conditions.merge(:ativo => true))
  # end
  # but that would not show a custom alert message
  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.ativo
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      sign_out(resource)
      flash[:alert] = "Sua conta está inativa, por favor contate o suporte!"
      redirect_to root_path
    end
  end

  # Verifica se uma sessão de cidadão já existe.
  # @note redireciona para a página principal com uma mensagem de
  #     alerta(+alert+).
  def sessao_cidadao
    if cidadao_signed_in?
      redirect_to root_url,
      alert: "Você já está logado."
    end 
  end
end

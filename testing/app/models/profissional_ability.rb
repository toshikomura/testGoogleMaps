# encoding: UTF-8
# Autorização dos profissionais, implementada usando a gem
# {https://github.com/ryanb/cancan CanCan}, cada {Profissional} possui um
# nível de permissão, atributo +role+, que garante acesso aos recursos,
# possui uma hierarquia e herança de acessos:
# Administrador Sistema > Administrador > Atendente > Técnico;
# ver referência
# {https://github.com/ryanb/cancan/wiki/Role-Based-Authorization#role-inheritance
# Role Inheritance}.
#
# @note A autorização do profissional é instânciada pelo controlador da aplicação,
#   ver {ApplicationController#current_ability}.
#
# @note Quando a autorização do CanCan falha levanta uma execção que é
#   tratada no controlador da aplicação {ApplicationController}, ver
#   referência {https://github.com/ryanb/cancan/wiki/exception-handling
#   CanCan Exception Handling}
class ProfissionalAbility
  include CanCan::Ability

  # Instância as permissões do profissional.
  # @param profissional [Profissional Object] profissional para a
  #     autorização.
  # @note Usa o método {Profissional#role?}.
  def initialize(profissional)
    if profissional.role? :tecnico
     can [:escalas,:atendimento,:atendimento_update], [Profissional]
     can [:manage], [Report]
    end
    if profissional.role? :atendente
      can :manage, [Agendamento]
    end
    if profissional.role? :administrador
      can :manage, [Escala]
    end
    if profissional.role? :administradorsistema
      can :manage, [Prefeitura,Orgao,TipoAtendimento,Profissional]
    end
    # CanCan 
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end

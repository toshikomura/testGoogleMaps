# encoding: UTF-8
Tabulous.setup do

  tabs do

    # O objetivo dessa tab é evitar que o in_action falhe e não gere nenhuma
    # tab quando acessar a tela de editar cadastro.
    hidden_tab do
      text          { 'Void' }
      link_path     { root_path }
      visible_when  { false }
      enabled_when  { false }
      active_when do
        in_action('edit').of_controller('devise/registrations')
        in_action('update').of_controller('devise/registrations')
      end
    end

    inicio_tab do
      text          { 'Início' }
      link_path     { root_path }
      visible_when  { true }
      enabled_when  { true }
      active_when   { in_action('any').of_controller('agendador') }
    end

#==============================================================================
#   Nenhum usuário logado

    cidadao_tab do
      text          { 'Cidadão' }
      link_path     { new_cidadao_session_path }
      visible_when  { not any_signed_in? }
      enabled_when  { true }
      active_when   { a_subtab_is_active }
    end

    new_cidadao_session_subtab do
      text          { 'Login Cidadão' }
      link_path     { new_cidadao_session_path }
      visible_when  { not any_signed_in? }
      enabled_when  { true }
      active_when   { in_action('new').of_controller('cidadaos/sessions') }
    end
    
    new_cidadao_registration_subtab do
      text          { 'Criar Conta' }
      link_path     { new_cidadao_registration_path }
      visible_when  { not any_signed_in? }
      enabled_when  { true }
      active_when do
        in_action('new').of_controller('devise/registrations')
        in_action('create').of_controller('devise/registrations')      
      end
    end

    hidden_cidadao_password_subtab do
      text          { 'Recuperar Senha Cidadão' }
      link_path     { new_cidadao_password_path }
      visible_when  { false }
      enabled_when  { false }
      active_when   { in_action('any').of_controller('devise/passwords') }
    end

    profissional_tab do
      text          { 'Profissional' }
      link_path     { new_profissional_session_path }
      visible_when  { not any_signed_in? }
      enabled_when  { true }
      active_when   { a_subtab_is_active }
    end

    hidden_new_profissional_session_subtab do
      text          { 'Profissional' }
      link_path     { new_profissional_session_path }
      visible_when  { false }
      enabled_when  { false }
      active_when   { in_action('new').of_controller('profissionais/sessions') }
    end

    hidden_profissional_password_subtab do
      text          { 'Recuperar Senha Profissional' }
      link_path     { new_profissional_password_path }
      visible_when  { false }
      enabled_when  { false }
      active_when   { in_action('any').of_controller('profissionais/passwords') }
    end

#==============================================================================
#   Cidadão logado

#    edit_cidadao_registration_tab do
#      text          { 'Alterar Minha Conta' }
#      link_path     { edit_cidadao_registration_path }
#      visible_when  { cidadao_signed_in? }
#      enabled_when  { true }
#      active_when   { in_action('edit').of_controller('devise/registrations') }
#    end

    cidadaos_agendamentos_termo_compromisso_tab do
      text          { 'Efetuar Agendamento' }
      link_path     { cidadaos_agendamentos_termo_compromisso_path }
      visible_when  { cidadao_signed_in? }
      enabled_when  { true }
      active_when do
        in_action('schedule_agreement').of_controller('cidadaos')
        in_action('schedule_select_facility').of_controller('cidadaos')
        in_action('schedule_select_service').of_controller('cidadaos')
        in_action('schedule_select_month').of_controller('cidadaos')
        in_action('schedule_select_day').of_controller('cidadaos')
        in_action('schedule_select_time').of_controller('cidadaos')
        in_action('schedule_finish').of_controller('cidadaos')
        in_action('schedule_save').of_controller('cidadaos')
      end
    end

    cidadaos_agendamentos_historico_tab do
      text          { 'Histórico de Agendamentos' }
      link_path     { cidadaos_agendamentos_historico_path }
      visible_when  { cidadao_signed_in? }
      enabled_when  { true }
      active_when   { in_action('history').of_controller('cidadaos') }
    end

#==============================================================================
#   Profissional logado

#    edit_profissional_registration_tab do
#      text          { 'Alterar Minha Conta' }
#      link_path     { edit_profissional_registration_path }
#      visible_when  { profissional_signed_in? }
#      enabled_when  { true }
#      active_when   { in_action('edit').of_controller('devise/registrations') }
#    end

    all_escalas_tab do
      text          { 'Escalas' }
      link_path     { profissionais_escalas_path }
      visible_when  { profissional_signed_in? }
      enabled_when  { true }
      active_when   { a_subtab_is_active }
    end
   
    profissionais_escalas_subtab do
      text          { 'Minhas Escalas' }
      link_path     { profissionais_escalas_path }
      visible_when  { profissional_signed_in? }
      enabled_when  { true }
      active_when   { in_action('escalas').of_controller('profissionais') }
    end

    #   Administrador
    escalas_subtab do
      text          { 'Escalas' }
      link_path     { escalas_path }
      visible_when  { administrador_signed_in? }
      enabled_when  { true }
      active_when   { in_action('any').of_controller('escalas') }
    end
 
    all_atendimentos_tab do
      text          { 'Atendimentos' }
      link_path     { profissionais_atendimento_path }
      visible_when  { profissional_signed_in? }
      enabled_when  { true }
      active_when   { a_subtab_is_active }     
    end

    profissionais_atendimento_subtab do
      text          { 'Meus Atendimentos' }
      link_path     { profissionais_atendimento_path }
      visible_when  { profissional_signed_in? }
      enabled_when  { true }
      active_when   { in_action('atendimento').of_controller('profissionais') }     
    end

    #   Atendente
    agendamentos_atendimento_subtab do
      text          { 'Atendimentos' }
      link_path     { agendamentos_atendimento_path }
      visible_when  { atendente_signed_in? }
      enabled_when  { true }
      active_when   { in_action('atendimento').of_controller('agendamentos') }     
    end

    agendamentos_tab do
      text          { 'Agendamentos' }
      link_path     { agendamentos_path }
      visible_when  { atendente_signed_in? }
      enabled_when  { true }
      active_when   { a_subtab_is_active }       
    end
    
    hidden_agendamentos_subtab do
      text          { 'Agendamentos' }
      link_path     { agendamentos_path }
      visible_when  { false }
      enabled_when  { false }
      active_when do
        in_action('index').of_controller('agendamentos')
        in_action('edit').of_controller('agendamentos')
        in_action('show').of_controller('agendamentos')
      end
    end 

#==============================================================================
#   Profissional administrador sistema logado

    sistema_tab do
      text          { 'Sistema' }
      link_path     { prefeituras_path }
      visible_when  { administradorsistema_signed_in? }
      enabled_when  { true }
      active_when   { a_subtab_is_active }
    end

    prefeitura_subtab do
      text          { 'Prefeitura' }
      link_path     { prefeituras_path }
      visible_when  { administradorsistema_signed_in? }
      enabled_when  { true }
      active_when   { in_action('any').of_controller('prefeituras') }
    end

    orgaos_subtab do
      text          { 'Locais de Atendimento' }
      link_path     { orgaos_path }
      visible_when  { administradorsistema_signed_in? }
      enabled_when  { true }
      active_when   { in_action('any').of_controller('orgaos') }
    end


    tipo_atendimentos_subtab do
      text          { 'Tipos de Atendimentos' }
      link_path     { tipo_atendimentos_path }
      visible_when  { administradorsistema_signed_in? }
      enabled_when  { true }
      active_when   { in_action('any').of_controller('tipo_atendimentos') }
    end

    profissionais_subtab do
      text          { 'Profissionais' }
      link_path     { profissionais_path }
      visible_when  { administradorsistema_signed_in? }
      enabled_when  { true }
      active_when do
        in_action('index').of_controller('profissionais')
        in_action('new').of_controller('profissionais')
        in_action('edit').of_controller('profissionais')
        in_action('show').of_controller('profissionais')
      end
    end

    reports_subtab do
      text          { 'Relatórios' }
      link_path     { reports_path }
      visible_when  { administradorsistema_signed_in? }
      enabled_when  { true }
      active_when   { in_action('any').of_controller('reports') }
    end

    maps_subtab do
      text          { 'Localização' }
      link_path     { maps_path }
      visible_when  { administradorsistema_signed_in? }
      enabled_when  { true }
      active_when   { in_action('any').of_controller('maps') }
    end
  end

  customize do
    # which class to use to generate HTML
    # :default, :html5, :bootstrap, or :bootstrap_pill
    # or create your own renderer class and reference it here
    # renderer :default
    renderer :default

    # whether to allow the active tab to be clicked
    # defaults to true
    # active_tab_clickable true
    active_tab_clickable true

    # what to do when there is no active tab for the currrent controller action
    # :render -- draw the tabset, even though no tab is active
    # :do_not_render -- do not draw the tabset
    # :raise_error -- raise an error
    # defaults to :do_not_render
    # when_action_has_no_tab :do_not_render
    when_action_has_no_tab :render

    # whether to always add the HTML markup for subtabs, even if empty
    # defaults to false
    # render_subtabs_when_empty false
    render_subtabs_when_empty true

  end

  # The following will insert some CSS straight into your HTML so that you
  # can quickly prototype an app with halfway-decent looking tabs.
  #
  # This scaffolding should be turned off and replaced by your own custom
  # CSS before using tabulous in production.
#  use_css_scaffolding do
#    background_color '#ccc'
#    text_color '#444'
#    active_tab_color '#fff'
#    hover_tab_color '#ddd'
#    inactive_tab_color '#aaa'
#    inactive_text_color '#888'
#  end
end

Agendador::Application.routes.draw do

  resources :reports, :except => [ :new, :edit, :update, :destroy ]

  post "reports/profissionais"
  post "reports/cidadaos"
  post "reports/agendamentos"
  post "reports/show"
  post "/reports/relatorio/gerar_relatorio_profissionais" => "reports#generate_profissionais_report"
  post "/reports/relatorio/gerar_relatorio_escalas" => "reports#generate_escalas_report"
  post "/reports/relatorio/gerar_relatorio_agendamentos" => "reports#generate_agendamentos_report"

  get "/reports/relatorio/tipo_relatorio" => "reports#schedule_select_type_report"
  get "/reports/relatorio/ano_relatorio" => "reports#schedule_select_year_report"
  get "/reports/relatorio/mes_relatorio" => "reports#schedule_select_month_report"
  get "/reports/relatorio/dia_relatorio" => "reports#schedule_select_day_report"
  get "/reports/relatorio/profissionais_relatorio" => "reports#schedule_select_profissionais_report"
  get "/reports/relatorio/escalas_relatorio" => "reports#schedule_select_escalas_report"
  get "/reports/relatorio/agendamentos_relatorio" => "reports#schedule_select_agendamentos_report"

  get "profissionais/escalas"

  get "profissionais/atendimento"
	put "profissionais/atendimento_update"
	post "profissionais/atendimento_update"

  devise_for :profissionais, :skip => [:registrations], :controllers =>
    {:sessions => "profissionais/sessions",
     :passwords => "profissionais/passwords"}

  as :profissional do
    get 'profissionais/edit' => 'devise/registrations#edit', :as =>
'edit_profissional_registration'
    put 'profissionais' => 'devise/registrations#update', :as =>
'profissional_registration'
  end

  resources :profissionais, :except => :destroy


  get "agendamentos/atendimento"
	put "agendamentos/atendimento_update"
	post "agendamentos/atendimento_update"

  resources :agendamentos, :only => [:index,:edit,:update,:show]


  devise_for :cidadaos, :skip => [:registrations], :controllers =>
{:sessions => "cidadaos/sessions"}
  
  as :cidadao do
    get 'cidadaos/edit' => 'devise/registrations#edit', :as =>
'edit_cidadao_registration'
    put 'cidadaos' => 'devise/registrations#update', :as =>
'cidadao_registration'
    get 'cidadaos/sign_up' => 'devise/registrations#new', :as =>
'new_cidadao_registration'
    post 'cidadaos' => 'devise/registrations#create', :as =>
'cidadao_registration'
  end


  get "/cidadaos/agendamentos/historico" => "cidadaos#history" 
  get "/cidadaos/agendamentos/termo_compromisso" => "cidadaos#schedule_agreement"
  get "/cidadaos/agendamentos/selecionar_tipo_atendimento" => "cidadaos#schedule_select_service"
  get "/cidadaos/agendamentos/selecionar_orgao" => "cidadaos#schedule_select_facility"
  #get "/cidadaos/agendamentos/selecionar_mes" => "cidadaos#schedule_select_month"
  get "/cidadaos/agendamentos/selecionar_dia" => "cidadaos#schedule_select_day"
  get "/cidadaos/agendamentos/selecionar_horario" => "cidadaos#schedule_select_time"
  get "/cidadaos/agendamentos/finalizar" => "cidadaos#schedule_finish"
  put "/cidadaos/agendamentos/salvar_agendamento" => "cidadaos#schedule_save"
  resources(:cidadaos, :path => "/cidadaos/agendamentos", :path_names => { :edit => "confirmar", :destroy => "cancelar" }, :only => [ :index, :edit, :update, :destroy ])

  resources :tipo_atendimentos, :except => :destroy


  resources :escalas
	post "escalas/remove_escala"


  resources :orgaos, :except => :destroy


  resources :prefeituras, :only => [:edit,:update,:index,:show]


  get "agendador/index"
  get "agendador/faq"
  get "agendador/contato"
  get "agendador/reportar"
  get "municipios" => "agendador#municipios", :module => "agendador", :format => :json

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'agendador#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)' 
end

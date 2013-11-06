set :rvm_ruby_string, 'version'
set :rvm_bin_path, "path rvm bin"
set :rvm_type, :system

# Add RVM's lib directory to the load path.
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

    set :domain, "name domain"
    set :application, "name aplication"
    set :repository,  "url repository"
    set :deploy_to, "url deploy"
    set :scm, :git
    set :deploy_via, :remote_cache
    set :copy_exclude, [".git", "spec"]
    set :scm_verbose, true
    set :user, "name user"
    set :use_sudo, false
    default_run_options[:pty] = true
    #Se o repositorio estiver em um host diferente descomentar as linhas
    #set :ssh_options, { :forwar_agent => true} #Usa chave local
    #ssh_options[:keys] = %w("onde/sua/chave/está/id_rsa") #Chave local
    #ssh_options[:port] = 80 #Porta do repositorio
    #ssh_options[:verbose] = :debug

    role :web, domain                          # Your HTTP server, Apache/etc
    role :app, domain                          # This may be the same as your `Web` server
    role :db,  domain, :primary => true # This is where Rails migrations will run
    # role :db,  "your slave db-server here"

    # if you want to clean up old releases on each deploy uncomment this:
    # after "deploy:restart", "deploy:cleanup"

    # if you're still using the script/reaper helper you will need
    # these http://github.com/rails/irs_process_scripts

    # If you are using Passenger mod_rails uncomment this:
    namespace :deploy do
     task :start do ; end
     task :stop do ; end
     task :restart, :roles => :app, :except => { :no_release => true } do
       run "touch #{File.join(current_path,'tmp','restart.txt')}"
     end
    end

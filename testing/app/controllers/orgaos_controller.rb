# encoding: UTF-8
class OrgaosController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource

  # GET /orgaos
  # GET /orgaos.json
  def index
	@search = Orgao.search(params[:q])
    @orgaos = @search.result.paginate(:page => params[:page], :per_page => 25)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @orgaos }
    end
  end

  # GET /orgaos/1
  # GET /orgaos/1.json
  def show
    @orgao = Orgao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orgao }
    end
  end

  # GET /orgaos/new
  # GET /orgaos/new.json
  def new
    @orgao = Orgao.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orgao }
    end
  end

  # GET /orgaos/1/edit
  def edit
    @orgao = Orgao.find(params[:id])
  end

  # POST /orgaos
  # POST /orgaos.json
  def create
    params[:orgao][:tipo_atendimento_ids] ||= []
	respond_to do |format|
      if @orgao.save
        format.html { redirect_to @orgao, notice: "Local de atendimento: #{@orgao.nome}, foi criado com sucesso." }
        format.json { render json: @orgao, status: :created, location: @orgao }
      else
        format.html { render action: "new" }
        format.json { render json: @orgao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orgaos/1
  # PUT /orgaos/1.json
  def update
    @orgao = Orgao.find(params[:id])

    params[:orgao][:tipo_atendimento_ids] ||= []
    respond_to do |format|
      if @orgao.update_attributes(params[:orgao])
		format.html { redirect_to @orgao, notice: "Local de atendimento: #{@orgao.nome}, foi atualizado com sucesso." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @orgao.errors, status: :unprocessable_entity }
      end
    end
  end
end

# encoding: UTF-8
class PrefeiturasController < ApplicationController
  before_filter :authenticate_profissional!
  load_and_authorize_resource

  # GET /prefeituras
  # GET /prefeituras.json
  def index
    @prefeitura = Prefeitura.first

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prefeitura }
    end
  end

  # GET /prefeituras/1
  # GET /prefeituras/1.json
  def show
    @prefeitura = Prefeitura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prefeitura }
    end
  end

  # GET /prefeituras/1/edit
  def edit
    @prefeitura = Prefeitura.find(params[:id])
  end

  # PUT /prefeituras/1
  # PUT /prefeituras/1.json
  def update
    @prefeitura = Prefeitura.find(params[:id])

    respond_to do |format|
      if @prefeitura.update_attributes(params[:prefeitura])
        format.html { redirect_to prefeituras_url, notice: "Prefeitura: #{@prefeitura.nome}, foi atualizada com sucesso." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prefeitura.errors, status: :unprocessable_entity }
      end
    end
  end
end

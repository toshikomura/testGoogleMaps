class AgendadorController < ApplicationController
  # GET /municipios.json?id=1
  def municipios
    @municipios = Tmibge.where("tufibge_id = ?", params[:id])

    respond_to do |format|
      format.json { render json: @municipios }
    end
  end
end

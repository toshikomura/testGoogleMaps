$(document).ready(->
  $('#reset_btn').click ->
    $('.search-field').val('')

  $("select#prefeitura_tufibge_id").change ->
    estado_id = $("select#prefeitura_tufibge_id option:selected").val()
    $("#prefeitura_tmibge_id").attr("disabled", "disabled");
    $("#prefeitura_tmibge_id").html "<option value=\"\">Selecione um Município </option>"
    if estado_id? and (estado_id != "")
      $("p#prefeitura_tmibge_id_loading").fadeIn(1000)

      jsonURL = $("input#lista_municipios").val()
      jsonURL += "municipios.json?id=" + parseInt(estado_id)

      jsonReq = $.getJSON(jsonURL)

      jsonReq.success((data) ->
        $(data).each ->
          $("#prefeitura_tmibge_id").append "<option value=\"" + @id + "\">" + @nome_municipio + "</option>"
          return

        $("#prefeitura_tmibge_id").removeAttr("disabled")
        return
      )

      jsonReq.fail( ->
        console.log "Falha no carregamento dos municípios!"
        return
      )

      $("p#prefeitura_tmibge_id_loading").fadeOut(1000)
      return
    return
  return
)

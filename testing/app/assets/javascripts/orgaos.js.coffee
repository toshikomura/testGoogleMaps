$(document).ready(->
  $('#reset_btn').click ->
    $('.search-field').val('')

  $("select#orgao_tufibge_id").change ->
    estado_id = $("select#orgao_tufibge_id option:selected").val()

    $("#orgao_tmibge_id").attr("disabled", "disabled");
    $("#orgao_tmibge_id").html "<option value=\"\">Selecione um Município </option>"

    if estado_id? and (estado_id != "")
      $("p#orgao_tmibge_id_loading").fadeIn(1000)

      jsonURL = $("input#lista_municipios").val()
      jsonURL += "municipios.json?id=" + parseInt(estado_id)

      jsonReq = $.getJSON(jsonURL)

      jsonReq.success((data) ->
        $(data).each ->
          $("#orgao_tmibge_id").append "<option value=\"" + @id + "\">" + @nome_municipio + "</option>"
          return
        $("#orgao_tmibge_id").removeAttr("disabled")
        return)

      jsonReq.fail( ->
        console.log "Falha no carregamento dos municípios!"
        return
      )

      $("p#orgao_tmibge_id_loading").fadeOut(1000)
      return
    return
  return
)

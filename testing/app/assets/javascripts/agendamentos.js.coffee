# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
$(document).ready(->
  $('#reset_btn').click ->
    $('.search-field').val('')

  $("#agendamento_buscar").click (e) ->
    e.preventDefault()

    # Change the schedule date to it's scale date.
    escala_ano = $("#q_escala_data_execucao_eq_1i").val()
    escala_mes = $("#q_escala_data_execucao_eq_2i").val()
    escala_dia = $("#q_escala_data_execucao_eq_3i").val()

    $("#q_horario_inicio_consulta_gteq_1i").val(escala_ano)
    $("#q_horario_inicio_consulta_gteq_2i").val(escala_mes)
    $("#q_horario_inicio_consulta_gteq_3i").val(escala_dia)
    $("#q_horario_inicio_consulta_lteq_1i").val(escala_ano)
    $("#q_horario_inicio_consulta_lteq_2i").val(escala_mes)
    $("#q_horario_inicio_consulta_lteq_3i").val(escala_dia)
    $("#agendamento_search").submit()
    return

  return
)

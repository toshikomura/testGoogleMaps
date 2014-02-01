# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#OBS: disable = true -> desabilita um campo

# Classe "Tempo"
class Tempo

  this.hoje_ano
  this.hoje_mes
  this.hoje_dia
  this.hoje_hora
  this.hoje_minutos

  # Método "atualiza" da classe "Tempo"
  this.atualiza = () ->
    hoje = new Date()
    this.hoje_ano = hoje.getFullYear()
    this.hoje_mes = hoje.getMonth()+1
    this.hoje_dia = hoje.getDate()
    this.hoje_hora = hoje.getHours()
    this.hoje_minutos = hoje.getMinutes()
    $("#clear_min").html(this.hoje_minutos)
# Fim da clase "Tempo"

# Método executada quando toda a página foi lida
$(document).ready(->

  # Chama o método da classe "Tempo"
  Tempo.atualiza()

  data_exec_ano = document.getElementById("escala_data_execucao_1i")
  data_exec_mes = document.getElementById("escala_data_execucao_2i")
  data_exec_dia = document.getElementById("escala_data_execucao_3i")
  init_hora = document.getElementById("escala_horario_inicio_execucao_4i")
  init_min = document.getElementById("escala_horario_inicio_execucao_5i")
  fim_hora = document.getElementById("escala_horario_fim_execucao_4i")
  fim_min = document.getElementById("escala_horario_fim_execucao_5i")
  n_atendimentos = document.getElementById("n_atendimentos")

  i=0
  $("#escala_data_execucao_2i option[value=#{i}]").remove() while i++ < Tempo.hoje_mes-1

  # Método que verifica e realiza a limpeza no campo
  # de número de atendimentos se necessário
  limpa_atend = () ->

    # Se o campo de minutos do fim de atendimento estiver vazio
    if fim_min.value == ""
      n_atendimentos.readOnly = true
      n_atendimentos.style.backgroundColor = "#D3D3D3"
      n_atendimentos.value = ""
      document.getElementById("select_atend").disabled = true
      document.getElementsByClassName("create_scale_btn")[0].disabled = true
      document.getElementById("rd_btn_atend_num").disabled = true
      document.getElementById("rd_btn_atend_inter").disabled = true
      document.getElementById("rd_btn_atend_num").checked = false
      document.getElementById("rd_btn_atend_inter").checked = false
      return;

    else
      n_atendimentos.value = ""
      $("#select_atend").val  ""
      $("#clear_min").html ""
      document.getElementsByClassName("create_scale_btn")[0].disabled = true
      document.getElementById("rd_btn_atend_num").disabled = false
      document.getElementById("rd_btn_atend_inter").disabled = false
      return;

  # Método que verifica e realiza a limpeza do campo
  # mês se necessário
  atualiza_mes = () ->

    # Se o campo ano estiver vazio
    if $("#escala_data_execucao_1i").val() == ""
      data_exec_mes.disabled = true
      data_exec_mes.value = ""
      data_exec_dia.disabled = true
      data_exec_dia.value = ""
      init_hora.disabled = true
      init_hora.value = ""
      init_min.disabled = true
      init_min.value = ""
      fim_hora.disabled = true
      fim_hora.value = ""
      fim_min.disabled = true
      fim_min.value = ""

      # Chama o método que verifica e realiza a limpeza
      # no campo de número de atendimentos se necessário
      limpa_atend()
      return;

    else
      data_exec_mes.disabled = false
      return;

  # Método que verifica e realiza a limpeza do campo
  # dia se necessário
  atualiza_dia = () ->
    i = 0

    # Desabilita e limpa todos os campos de horário e minuto da escala
    init_hora.disabled = true
    init_hora.value = ""
    init_min.disabled = true
    init_min.value = ""
    fim_hora.disabled = true
    fim_hora.value = ""
    fim_min.disabled = true
    fim_min.value = ""

    # Chama o método que verifica e realiza a limpeza
    # no campo de número de atendimentos se necessário
    limpa_atend()

    # Se o campo mês estiver vazio
    if data_exec_mes.value == ""
      data_exec_dia.disabled = true
      data_exec_dia.value = ""
      return;

    else
      data_exec_dia.disabled = false

      # Se o campo mês estiver com o mês atual
      if parseInt(data_exec_mes.value) == Tempo.hoje_mes
        $("#escala_data_execucao_3i option[value=#{i}]").remove() while i++ < Tempo.hoje_dia-1
      else
        data_exec_dia.options.lenght = 0
        data_exec_dia.options[i] = new Option(i, i) while i++ < 31
      return;

  # Método que verifica e remove valores desnecessários
  # do campo minuto
  updateMin = () ->
    i= 0
    min = 0

    # Se o campo dia estiver no dia atual e o mês estiver no mês atual
    # e a hora na hora atual
    if parseInt(data_exec_dia.value) == Tempo.hoje_dia && parseInt(data_exec_mes.value) == Tempo.hoje_mes && parseInt(init_hora.value, 10 ) == Tempo.hoje_hora

      # Enquanto o i for menor ou igual ao minuto atual
      while i <= Tempo.hoje_minutos
        # Para o primeiro e segundo loop remove 00 e 05
        if i >= 10
          $("#escala_horario_inicio_execucao_5i option[value=#{i}]").remove()
          i = i+5
        else
          $("#escala_horario_inicio_execucao_5i option[value=0#{i}]").remove()
          i = i+5
      return;

    else
      init_min.options.lenght = 0

      # Enquanto não fechar uma hora em minutos de 5 em 5
      while i < 12
        # Para o primeiro e segundo loop insere 0 e 5 respectivamente
        if min < 10
          init_min.options[i+1] = new Option('0'+min, '0'+min)
          i++
          min=min+5
        else
          init_min.options[i+1] = new Option(min, min)
          i++
          min=min+5
      return;

  # Méotodo que recarrega os campo de minuto
  loadMin = () ->
    # Chama o método que atualiza as variáveis de tempo
    Tempo.atualiza()

    # Se o campo minuto estiver no minuto atual e se o campo hora estiver na hora
    # atual e se o dia estiver no dia atual
    if parseInt(init_min.value, 10) == Tempo.hoje_minutos && parseInt(init_hora.value, 10) == Tempo.hoje_hora && parseInt(data_exec_dia.value, 10) == Tempo.hoje_dia
      init_min.value = ""
      fim_hora.disabled = true
      fim_hora.value = ""
      fim_min.disabled = true
      fim_min.value =""

      # Chama o método que verifica e realiza a limpeza
      # no campo de número de atendimentos se necessário
      limpa_atend();

      # Chama o método que verifica e remove valores desnecessários do campo minuto
      updateMin()
      return;

  #Carrega o select do mes
  $("#escala_data_execucao_1i").change ->
    # Chama o método que carrega os campos a partir do campo mês se necessário
    atualiza_mes()
    return;

  #Carrega o select do dia
  $("#escala_data_execucao_2i").change ->
    # Chama o método que carrega os campos a partir do campo dia se necessário
    atualiza_dia()
    return;

  #Carrega o select da hora do horario de inicio
  $("#escala_data_execucao_3i").change ->
    i=-1
    init_min.disabled = true
    init_min.value = ""
    fim_hora.disabled = true
    fim_hora.value = ""
    fim_min.disabled = true
    fim_min.value = ""

    # Chama o método que verifica e realiza a limpeza
    # no campo de número de atendimentos se necessário
    limpa_atend()

    # Se o campo dia estiver vazio
    if data_exec_dia.value == ""
      init_hora.disabled = true
      init_hora.value = ""
    else
      init_hora.disabled = false

      # Se o camo dia estiver no dia atual e se o campo mês estiver no mês atual
      if parseInt(data_exec_dia.value) == Tempo.hoje_dia && parseInt(data_exec_mes.value) == Tempo.hoje_mes

        # Se não existir a possibilidade de inserir tempos aumenta a hora
        if Tempo.hoje_minutos >= 55
          Tempo.hoje_hora++;

        # Enquanto i não chegar na hora atual
        while i++ < Tempo.hoje_hora-1
          # Remove para os 9 primeiros loops 01, 02, ....
          if i >= 10
            $("#escala_horario_inicio_execucao_4i option[value=#{i}]").remove()
          else
            $("#escala_horario_inicio_execucao_4i option[value=0#{i}]").remove()
        return;

      else
        i=-1
        init_hora.options.lenght = 0
        init_hora.disabled = false

        # Enquanto i for menor que 23 (24h)
        while i++ < 23
          # Cria para os 9 primeiros loops 01, 02, ....
          if i < 10
            init_hora.options[i+1] = new Option('0'+i, '0'+i)
          else
            init_hora.options[i+1] = new Option(i, i)
        return;

  #Carrega o select dos minutos do horario de inicio
  $("#escala_horario_inicio_execucao_4i").change ->
    i=0
    min=0
    interval;
    fim_hora.disabled = true
    fim_hora.value = ""
    fim_min.disabled = true
    fim_min.value = ""

    # Chama o método que verifica e realiza a limpeza
    # no campo de número de atendimentos se necessário
    limpa_atend()

    # Se o campo de hora de inicio da escala estiver vazio
    if init_hora.value == ""
      init_min.disabled = true
      init_min.value = ""
      return;

    else
      init_min.disabled = false

      # Se o campo de dia estiver no dia atual e se o campo mês estiver no mês atual
      # e se o campo ano estiver no ano atual
      if parseInt(data_exec_dia.value) == Tempo.hoje_dia && parseInt(data_exec_mes.value) == Tempo.hoje_mes && parseInt(init_hora.value, 10 ) == Tempo.hoje_hora
        # Chama o método que verifica e remove valores desnecessários do campo minuto
        updateMin()

        # Chama o método que carrega os campos dos minutos a cada 1s se necessário
        interval = setInterval loadMin, 1000
      else

        # Somente chama o método que verifica e remove valores desnecessários do campo minuto
        updateMin()
      return;


  $("#escala_horario_inicio_execucao_5i").click ->
    # Se o campo de dia estiver no dia atual e se o campo de mês estiver no mês atual
    # e se o campo ano estiver no ano atual
    if parseInt(data_exec_dia.value) == Tempo.hoje_dia && parseInt(data_exec_mes.value) == Tempo.hoje_mes && parseInt(init_hora.value, 10 ) == Tempo.hoje_hora
      # Chama o método que verifica e remove valores desnecessários do campo minuto
      updateMin();

  #Carrega o select da hora do fim de execucao
  $("#escala_horario_inicio_execucao_5i").change ->
    i=-1
    hora_exec = parseInt(init_hora.value, 10)
    fim_min.disabled = true
    fim_min.value =""

    # Chama o método que verifica e realiza a limpeza
    # no campo de número de atendimentos se necessário
    limpa_atend();

    # Se o campo de minutos do inicio da escala estiver vazio
    if init_min.value == ""
      fim_hora.disabled = true
      fim_hora.value = ""
      return;

    else
      fim_hora.disabled = false
      i=-1
      fim_hora.options.lenght = 0
      fim_hora.disabled = false

      # Enquanto i for menor que 23 (24h)
      while i++ < 23
        # Para os 10 primeiros loops insere 00, 01, 02, ...
        if i < 10
          fim_hora.options[i+1] = new Option('0'+i, '0'+i)
        else
          fim_hora.options[i+1] = new Option(i, i)

      i=-1
      # Se o campo de minutos do inicio da escala for
      # diferenete de 55 reduz uma hora da escala
      if parseInt(init_min.value, 10) != 55
        hora_exec--

      # Enquanto i for menor que a qauntidade de horas da escala
      while i++ < hora_exec
        # Para os 10 primeiro loops remove 00, 01, 02, ...
        if i >= 10
          $("#escala_horario_fim_execucao_4i option[value=#{i}]").remove()
        else
          $("#escala_horario_fim_execucao_4i option[value=0#{i}]").remove()
      return;

  #Carrega o select dos minutos do fim da execucao
  $("#escala_horario_fim_execucao_4i").change ->
    i=0
    min=0
    # Se o campo da hora de fim da escala estiver vazio
    if fim_hora.value == ""
      fim_min.disabled = true
      fim_min.value = ""

      # Chama o método que verifica e realiza a limpeza
      # no campo de número de atendimentos se necessário
      limpa_atend()
      return;

    else
      fim_min.disabled = false
      init_min.options.lenght = 0
      init_min.disabled = false

      # Enquanto não fechar 1h em minutos de 5 em 5
      while i < 12
        # Para os 2 primeiros loops insere 00 e 05
        if min < 10
          fim_min.options[i+1] = new Option('0'+min, '0'+min)
          i++
          min=min+5
        else
          fim_min.options[i+1] = new Option(min, min)
          i++
          min=min+5

      i=0
      # Se o campo de hora de fim da escala for igual ao campo hora de inicio da escala
      if fim_hora.value == init_hora.value
        # Enquanto não chegar no minuto de inicio da escala remove o minuto
        while i < parseInt(init_min.value, 10)+5
          if i >= 10
            $("#escala_horario_fim_execucao_5i option[value=#{i}]").remove()
            i = i+5
          else
            $("#escala_horario_fim_execucao_5i option[value=0#{i}]").remove()
            i = i+5
      return;

  #Libera o select de intervalo, e o campo par colocar o numero de atendimentos
  $("#escala_horario_fim_execucao_5i").change ->
    # Chama o método que verifica e realiza a limpeza
    # no campo de número de atendimentos se necessário
    limpa_atend()
    return;

  #Remove a opção de intervalo de 0 minutos.
  $("#select_atend option[value='00']").remove();

  #Funções para liberar a saida da pagina.
  $("#reset_btn").click ->
    $(".search-field").val('')
    return;

  $(".save_scale_btn").click ->
    (window).btn_clicked = true
    return;

  $(".remove_scale_btn").click ->
    (window).btn_clicked = true
    return;

  $(".create_scale_btn").click ->
    (window).btn_clicked = true
    return;

  #Calcula o número de atendimentos pelo select.
  $("#select_atend").change ->
    # Se o campo que calcula o número de atendimentos estiver vazio
    if $.trim($("#select_atend").val()) is ""
      n_atendimentos.value = ''
      n_atendimentos.readOnly = true
      n_atendimentos.style.backgroundColor = "#D3D3D3"
      $("#clear_min").html ''
      document.getElementsByClassName("create_scale_btn")[0].disabled = true
      return;

    # Senão estiver vazio calcula o número de atendimentos
    else
      atendimentos = ((fim_hora.value - init_hora.value)*60 + (fim_min.value - init_min.value))
      intervalo = $("#select_atend").val()
      n_atend = Math.floor(atendimentos/intervalo)
      n_atendimentos.value = n_atend
      n_atendimentos.readOnly = true
      n_atendimentos.style.backgroundColor = "#D3D3D3"
      $("#clear_min").html "<input type='button' value='Limpar' id='limpar_atend'></input>"
      document.getElementsByClassName("create_scale_btn")[0].disabled = false
      return;

  #Função do botão para limpar o campo de numero de atendimentos.
  $("#clear_min").click ->
    n_atendimentos.value = ''
    $("#clear_min").html ""
    $("#select_atend").val ''
    document.getElementsByClassName("create_scale_btn")[0].disabled = true
    return;

  #Expressão regular para verificar se é um número, utilizada no campo numero de atendimentos.
  isNumber = (number) ->
    numRegExp = /^[0-9]+$/
    return(!numRegExp.test(number))

  #Verificação para número de atendimentos.
  $("#n_atendimentos").change ->
    # Se o campo de número de atendimentos estiver vazio
    if n_atendimentos.value == ""
      document.getElementsByClassName("create_scale_btn")[0].disabled = true
      return;

    else
      # Se valor que esta no campo não é um número
      if isNumber($("#n_atendimentos").val())
        alert "Erro: Número de Atendimentos especificado não é um número!"
        document.getElementsByClassName("create_scale_btn")[0].disabled = true
        return;

      else
        # Calcula o tempo máximo de atendimentos
        max_atendimentos = ((fim_hora.value - init_hora.value)*60 + (fim_min.value - init_min.value))
        # Se o número de atendimentos for maior que o tempo máximo de atendimento
     	if parseInt($("#n_atendimentos").val()) > max_atendimentos
          alert "Erro: Número de Atendimentos é maior do que o número máximo permitido! O número máximo de atendimentos é: "+ max_atendimentos
          document.getElementsByClassName("create_scale_btn")[0].disabled = true
          return;

        else
          document.getElementsByClassName("create_scale_btn")[0].disabled = false
          return;

  # Bloqueia o campo de atendimentos
  $("#rd_btn_atend_num").change ->
    $("#select_atend").val ''
    $("#clear_min").html ""
    document.getElementById("select_atend").disabled = true
    n_atendimentos.style.backgroundColor = "#FFFFFF"
    n_atendimentos.readOnly = false
    return;

  # Desbloqueia o campo de atendimentos
  $("#rd_btn_atend_inter").change ->
    document.getElementsByClassName("create_scale_btn")[0].disabled = true
    n_atendimentos.value = ''
    n_atendimentos.style.backgroundColor = "#D3D3D3"
    n_atendimentos.readOnly = true
    document.getElementById("select_atend").disabled = false
    return;

  # Seleciona lista de profissionais dependendo do local de atendimento
  $("select#escala_orgao_id").change ->
    local_de_atendimento_id = $("select#escala_orgao_id option:selected").val()
    $("#escala_profissional_executor_id").attr("disabled", "disabled");
    $("#escala_tipo_atendimento_id").attr("disabled", "disabled");
    $("#escala_profissional_executor_id").html "<option value=\"\">Selecione um Profissional </option>"
    $("#escala_tipo_atendimento_id").html "<option value=\"\">Selecione um Tipo de Atendimento </option>"
    data_exec_ano.disabled = true
    data_exec_ano.value = ""
    atualiza_mes()
    # Se local de atendimento exisitir e não estiver vazio
    if local_de_atendimento_id? and (local_de_atendimento_id != "")
      $("#escala_data_execucao_1i").removeAttr("disabled")
      $("p#escala_profissional_executor_id_loading").fadeIn(1000)
      $("p#escala_tipo_atendimento_id_loading").fadeIn(1000)

      jsonURL = $("input#lista_profissionais").val()
      jsonURL += "profissionais_executores.json?id=" + parseInt(local_de_atendimento_id)
      jsonReq = $.getJSON(jsonURL)

      jsonReq.success((data) ->
        $(data).each ->
          $("#escala_profissional_executor_id").append "<option value=\"" + @id + "\">" + @nome + "</option>"
          return

        $("#escala_profissional_executor_id").removeAttr("disabled")
        return
      )

      jsonReq.fail( ->
        console.log "Falha no carregamento dos profissionais!"
        return
      )

      jsonURL = $("input#lista_tipo_atendimentos").val()
      jsonURL += "tipo_atendimentos_local_de_atendimento.json?id=" + parseInt(local_de_atendimento_id)
      jsonReq = $.getJSON(jsonURL)

      jsonReq.success((data) ->
        $(data).each ->
          $("#escala_tipo_atendimento_id").append "<option value=\"" + @id + "\">" + @descricao + "</option>"
          return

        $("#escala_tipo_atendimento_id").removeAttr("disabled")
        return
      )

      jsonReq.fail( ->
        console.log "Falha no carregamento dos profissionais!"
        return
      )

      $("p#escala_profissional_executor_id_loading").fadeOut(1000)
      $("p#escala_tipo_atendimento_id_loading").fadeOut(1000)
      return
    return
  return
)

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.cookie
//= require jquery_ujs
//= require_tree .
//= require maskedinput

jQuery(function($){
  $(".phone").mask("(99)9999-9999");
  $(".cep").mask("99999-999");
  $(".cpf").mask("999.999.999-99");
  $(".rg").mask("99.999.999-9");


  // Constantes para tamanho da fonte
  var MIN = 12;
  var PADRAO = 16;
  var MAX = 19;
  var tamanho_fonte = PADRAO;
  var COOKIE_NAME = "_agendador_tamanho_fonte";

  // Tamanho da fonte pelo cookie
  if($.cookie(COOKIE_NAME)){
    tamanho_fonte = parseInt($.cookie(COOKIE_NAME));
    if(tamanho_fonte >= MIN || tamanho_fonte <= MAX){
      $("body").css("font-size", tamanho_fonte + "px");
    }
  }

  // Diminuir fonte
  $("#diminuir-fonte").click(function (event) {
    event.preventDefault();
    if(tamanho_fonte >= MIN){
      tamanho_fonte--;
      $("body").css("font-size", tamanho_fonte + "px");
      $.cookie(COOKIE_NAME, tamanho_fonte, {path:'/'});
    }
  });

  // Fonte padrão
  $("#fonte-padrao").click(function (event) {
    event.preventDefault();
    tamanho_fonte = PADRAO;
    $("body").css("font-size", tamanho_fonte + "px");
    $.cookie(COOKIE_NAME, tamanho_fonte, {path:'/'});
  });

  // Aumentar fonte
  $("#aumentar-fonte").click(function (event) {
    event.preventDefault();
    if(tamanho_fonte <= MAX){
      tamanho_fonte++;
      $("body").css("font-size", tamanho_fonte + "px");
      $.cookie(COOKIE_NAME, tamanho_fonte, {path:'/'});
    }
  });
});

// Esconder a noticia automaticamente
setTimeout((function() {
  $("#alert").fadeOut("slow");
  return $("#notice").fadeOut("slow");
}), 2000);

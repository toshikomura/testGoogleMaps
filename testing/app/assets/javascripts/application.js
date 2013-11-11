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
  var MAX = 20;
  var tamanho_fonte = PADRAO;
  var COOKIE_FONTE = "_agendador_tamanho_fonte";
  var re = /fonte\S+/g; 
  
  // Tamanho da fonte pelo cookie
  if($.cookie(COOKIE_FONTE)){
    tamanho_fonte = parseInt($.cookie(COOKIE_FONTE));
    if(tamanho_fonte >= MIN || tamanho_fonte <= MAX){
      $("body").removeClass(function(index, css) {
        return (css.match(re) || []).join(' ');
      });
      $("body").addClass("fonte" + tamanho_fonte);
    }
  }

  // Diminuir fonte
  $("#diminuir-fonte").click(function (event) {
    event.preventDefault();
    if(tamanho_fonte > MIN){
      tamanho_fonte--;
      $("body").removeClass(function(index, css) {
        return (css.match(re) || []).join(' ');
      });
      $("body").addClass("fonte" + tamanho_fonte);
      $.cookie(COOKIE_FONTE, tamanho_fonte, {path:'/'});
    }
  });

  // Fonte padrão
  $("#fonte-padrao").click(function (event) {
    event.preventDefault();
    tamanho_fonte = PADRAO;
    $("body").removeClass(function(index, css) {
      return (css.match(re) || []).join(' ');
    });
    $("body").addClass("fonte" + tamanho_fonte);
    $.cookie(COOKIE_FONTE, tamanho_fonte, {path:'/'});
  });

  // Aumentar fonte
  $("#aumentar-fonte").click(function (event) {
    event.preventDefault();
    if(tamanho_fonte < MAX){
      tamanho_fonte++;
      $("body").removeClass(function(index, css) {
        return (css.match(re) || []).join(' ');
      });
      $("body").addClass("fonte" + tamanho_fonte);
      $.cookie(COOKIE_FONTE, tamanho_fonte, {path:'/'});
    }
  });

  // Alto contraste pelo cookie
  var COOKIE_CONTRASTE = "_agendador_alto_contraste";
  var contraste = "false";

  if($.cookie(COOKIE_CONTRASTE)){
    contraste = $.cookie(COOKIE_CONTRASTE);
    if(contraste == "true"){
      $("body").addClass("alto-contraste");
      $("#footer-images .img-padrao").hide();
      $("#footer-images .img-alto-contraste").show();
    } else if(contraste == "false") {
      $("body").removeClass("alto-contraste");
      $("#footer-images .img-alto-contraste").hide();
      $("#footer-images .img-padrao").show();
    }
  }

  $("#alto-contraste").click(function (event) {
    event.preventDefault();
    if(contraste == "true"){
      // Estava em alto contraste, vai para o padrão
      $("body").removeClass("alto-contraste");
      $("#footer-images .img-alto-contraste").hide();
      $("#footer-images .img-padrao").show();
      contraste = "false";
      $.cookie(COOKIE_CONTRASTE, contraste, {path:'/'});
    } else if(contraste == "false"){
      // Estava no padrão, vai para o alto contraste
      $("body").addClass("alto-contraste");
      $("#footer-images .img-padrao").hide();
      $("#footer-images .img-alto-contraste").show();
      contraste = "true";
      $.cookie(COOKIE_CONTRASTE, contraste, {path:'/'});
    }
  });
});

// Esconder a noticia automaticamente
setTimeout((function() {
  $("#alert").fadeOut("slow");
  return $("#notice").fadeOut("slow");
}), 2000);

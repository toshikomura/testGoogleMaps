#!/bin/bash

SCAFFOLD="rails g scaffold"
MODEL="rails g model"
CONTRL="rails g controller"
MIGRATION="rails g migration"
TEST="rake test"

echo "Gerando Scaffold Prefeitura:"
$SCAFFOLD Prefeitura \
  nome:string \
  cep:string \
  bairro:string \
  endereco:string \
  numero_endereco:integer \
  complemento_endereco:string \
  telefone1:string \
  telefone2:string \
  email:string \
  logo:string \
  tufibge:references \
  tmibge:references

echo "Gerando Scaffold Órgão da prefeitura:"
$SCAFFOLD Orgao \
  nome:string \
  cep:string \
  bairro:string \
  endereco:string \
  numero_endereco:integer \
  complemento_endereco:string \
  telefone1:string \
  telefone2:string \
  email:string \
  url:string \
  tufibge:references \
  tmibge:references \
  prefeitura:references

echo "Gerando Scaffold Profissional:"
$SCAFFOLD Profissional \
  nome:string \
  data_nascimento:date \
  cpf:string \
  rg:string \
  emissao_rg:string \
  carteira_trabalho:string \
  serie_carteira_trabalho:string \
  cep:string \
  bairro:string \
  endereco:string \
  numero_endereco:integer \
  complemento_endereco:string \
  telefone1:string \
  telefone2:string \
  email:string \
  tufibge_trabalho_id:integer \
  tufibge_endereco_id:integer \
  tmibge:references \
  tcbo:references \
  tconselho:references \
  orgao:references \
  hashed_password:string

echo "Gerando Scaffold Escala:"
$SCAFFOLD Escala \
  numero_sequencia:integer \
  data_execucao:date \
  horario_inicio_execucao:time \
  horario_fim_execucao:time \
  observacoes:text \
  numero_atendimentos:integer \
  profissional_executor_id:integer \
  profissional_responsavel_id:integer \
  tipo_atendimento:references \
  orgao:references \
  tipo_acao:references

echo "Gerando Scaffold Agendamento:"
$SCAFFOLD Agendamento \
  horario_inicio_consulta:time \
  horario_fim_consulta:time \
  tipo_situacao:references \
  escala:references \
  cidadao:references \
  orgao:references

echo "Gerando Model Bloqueio:"
$MODEL Bloqueio \
  data_entrada:date \
  data_expira:date \
  cidadao:references

echo "Gerando Scaffold Cidadão:"
$SCAFFOLD Cidadao \
  nome:string \
  cpf:string \
  rg:string \
  telefone1:string \
  email:string \
  cartao_sus:string \
  hashed_password:string

echo "Gerando Scaffold Tipo de Atendimento:"
$SCAFFOLD TipoAtendimento \
  profissional:references \
  descricao:string

echo "Gerando Model Tipo de Ação:"
$MODEL TipoAcao \
  descricao:string

echo "Gerando Model Tipo Situacao:"
$MODEL TipoSituacao \
  descricao:string

echo "Gerando Migration Órgãos e Tipo de Atendimentos join table:"
$MIGRATION create_orgao_tipo_atendimento_join_table

echo "Gerando Controller Atendimento:"
$CONTRL Atendimento index

echo "Gerando Model tufibge:"
$MODEL tufibge \
    sigla_uf:string \
    codigo_ibge:string \
    nome_uf:string

echo "Gerando Model tmibge:"
$MODEL tmibge \
    codigo_ibge:string \
    nome_municipio:string

echo "Gerando Model tcbo:"
$MODEL tcbo \
    codigo_cbo:string \
    descricao:string

echo "Gerando Model tconselho:"
$MODEL tconselho \
    sigla_conselho:string \
    descricao:string

echo "Gerando controller agendador:"
$CONTRL Agendador index

echo "Rake Test:"
$TEST

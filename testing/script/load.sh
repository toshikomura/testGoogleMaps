#!/bin/bash
RUNNER="rails runner"
DIR="script"

echo "Carregando CSV tipo de situações:"
$RUNNER $DIR/tipo_situacoes.rb

echo "Carregando CSV tipo de ações:"
$RUNNER $DIR/tipo_acoes.rb

echo "Carregando CSV unidades da federação(tufibges):"
$RUNNER $DIR/tufibges.rb

echo "Carregando CSV municipios(tmibges):"
$RUNNER $DIR/tmibges.rb

echo "Carregando CSV classificação de ocupações(tcbos):"
$RUNNER $DIR/tcbos.rb

echo "Carregando CSV conselhos(tconselhos):"
$RUNNER $DIR/tconselhos.rb

echo "Carregando exemplos:"
$RUNNER $DIR/exemplos.rb

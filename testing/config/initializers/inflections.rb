# Be sure to restart your server when you modify this file.

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'profissional', 'profissionais'
  inflect.irregular 'tipo_acao','tipo_acoes'
  inflect.irregular 'tipo_situacao','tipo_situacoes'
  inflect.irregular 'tufibge','tufibges'
  inflect.irregular 'tmibge','tmibges'
  inflect.irregular 'tcbo','tcbos'
  inflect.irregular 'tconselho','tconselhos'
end

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end

module RemoteLinkPaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    # Adiciona nas opções do will_paginate um link remoto(data-remote="true")
    # para fazer uma requisição ajax, para isso utiliza o helper
    # remote_link_pagination_helper, referência:
    # {https://gist.github.com/jeroenr/3142686}
    # @note Usamos isso para a versão 3.0.5 da gem will_paginate, caso isso
    #     seja implementado nas próximas versões o melhor seria remover
    #     esses helpers.
    def link(text, target, attributes = {})
      attributes['data-remote'] = true
      super
    end
  end
end

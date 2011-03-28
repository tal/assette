file_path 'public'
file_path 'foo'

asset_host 'http://cdn.gilt.com'
asset_hosts 'http://cdn1.gilt.com', 'http://cdn2.gilt.com'

asset_dir 'myassets'
templates_path 'myapp/templates'

template_preloader 'javascripts/handlebars.js'
template_partial 'Handlebars.registerPartial({*path*},{*template*});'

template_format 'GC.foo.t[{*path*}] = Handlebars.compile({*template*});'


after_compile do
  a = 1
  a + 2
end
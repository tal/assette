file_path 'public'
file_path 'foo'

asset_host 'http://cdn.gilt.com'
asset_hosts 'http://cdn1.gilt.com', 'http://cdn2.gilt.com'

asset_dir 'myassets'
asset_version_file 'myassets/version'
templates_path 'myapp/templates'

template_preloader 'javascripts/handlebars.js'
template_partial 'Handlebars.registerPartial({*path*},{*template*});'

template_format 'GC.foo.t[{*path*}] = Handlebars.compile({*template*});'

cache_method 'path'

minify true

after_compile do |sha|
  3
end

# cachebuster_string do
#   'mysha'
# end

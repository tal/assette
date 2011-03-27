file_path 'public'
file_path 'foo'

asset_host 'http://cdn.gilt.com'
asset_hosts 'http://cdn1.gilt.com', 'http://cdn2.gilt.com'

asset_dir 'myassets'
templates_path 'myapp/templates'
template_format 'GC.foo.t[{*path*}] = func({*template*});'

after_compile do
  a = 1
  a + 2
end
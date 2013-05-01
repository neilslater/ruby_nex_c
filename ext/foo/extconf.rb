# ext/foo/extconf.rb

require 'mkmf'
extension_name = 'foo'
dir_config(extension_name)
create_makefile(extension_name)

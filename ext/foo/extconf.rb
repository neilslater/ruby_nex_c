# frozen_string_literal: true

# ext/foo/extconf.rb
require 'mkmf'
require 'rbconfig'

native_mode = ENV.fetch('FOO_NATIVE_MODE', 'release')

case native_mode
when 'release'
  # Retain the optimisation and portability flags selected by the current Ruby.
when 'lint'
  $CFLAGS << ' -std=c11 -O0 -g'
  $CFLAGS << ' -Wall -Wextra -Wpedantic -Wformat=2 -Werror'

  cc = RbConfig::CONFIG.fetch('CC')
  host_os = RbConfig::CONFIG.fetch('host_os')
  if cc.match?(/clang/) || host_os.match?(/darwin/)
    # Ruby 4 headers use C23 attributes, ANYARGS declarations, and no-op parameters under C11.
    $CFLAGS << ' -Wno-c23-extensions -Wno-strict-prototypes -Wno-unused-parameter'
  end
when 'coverage'
  $CFLAGS << ' -O0 -g --coverage'
  $LDFLAGS << ' --coverage'
when 'sanitize'
  $CFLAGS << ' -O1 -g -fsanitize=address,undefined'
  $CFLAGS << ' -fno-omit-frame-pointer'
  $LDFLAGS << ' -fsanitize=address,undefined'
else
  abort "Unknown FOO_NATIVE_MODE: #{native_mode}"
end

create_makefile('foo/foo')

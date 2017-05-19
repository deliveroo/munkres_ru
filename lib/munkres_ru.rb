require 'munkres_ru/version'
require 'ffi'
require 'json'

if RUBY_PLATFORM.include?('darwin')
  EXT = 'dylib'
else
  EXT = 'so'
end

module MunkresRu
  extend FFI::Library
  ffi_lib "#{File.dirname(__FILE__)}/../rust/target/release/libmunkres_ru.#{EXT}"
  attach_function :double_input, [ :int ], :int
end

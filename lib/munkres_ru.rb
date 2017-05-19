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

  class ResultArray < FFI::Struct
    layout :len,    :size_t, # dynamic array layout
           :data,   :pointer #

    def to_a
      self[:data].get_array_of_int(0, self[:len]).compact
    end
  end

  attach_function :solve_munkres, [:int, :pointer], ResultArray.by_value

  def self.solve(array)
    n = array.size
    flattened = array.flatten
    offset = 0

    pointer = FFI::MemoryPointer.new :double, flattened.size

    pointer.put_array_of_double offset, flattened

    Hash[MunkresRu.solve_munkres(n, pointer).to_a.each_slice(2).to_a]

  end
end

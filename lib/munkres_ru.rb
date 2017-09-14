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
    layout :len,    :size_t,
           :data,   :pointer

    def to_a
      self[:data].get_array_of_int(0, self[:len]).compact
    end
  end

  attach_function :solve_munkres, [:size_t, :pointer], ResultArray
  attach_function :free_munkres, [ :pointer ], :void

  def self.solve(array)
    flattened = array.flatten
    pointer = FFI::MemoryPointer.new :double, flattened.size
    pointer.autorelease = false # Rust will take ownership of that memory
    pointer.put_array_of_double 0, flattened
    result_pointer = MunkresRu.solve_munkres(array.size, pointer)
    if result_pointer.null?
      raise 'Solving Munkres problem failed, check if input is valid'
    end
    result = ResultArray.new(result_pointer).to_a.each_slice(2).to_a
    self.free_munkres(result_pointer)
    result
  end
end

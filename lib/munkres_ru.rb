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

  attach_function :solve_munkres, [:size_t, :pointer], ResultArray.by_value

  def self.solve(array)
    flattened = array.flatten
    pointer = FFI::MemoryPointer.new :double, flattened.size
    pointer.autorelease = false # Rust will take ownership of that memory
    pointer.put_array_of_double 0, flattened
    solved = MunkresRu.solve_munkres(array.size, pointer).to_a
    if solved.include?(-1)
      raise 'Solving Munkres problem failed, check input is valid'
    end
    solved.each_slice(2).to_a
  end
end

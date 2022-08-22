# frozen_string_literal: true

class FactoryClass
  def self.create(class_name, _params)
    klass = Object.const_get(class_name)
    klass.new
    # if !pool_size
    #   puts "creating class instance"
    #   klass.new
    # else
    #   puts "creating pool in factory"
    #   klass.pool(size: pool_size)
    # end
  rescue Exception => e
    puts "error -> #{e.message}"
    raise 'There is no radar implemented for the service that initiated the call.'
  end
end

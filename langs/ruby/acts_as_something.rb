module ActsAsSomething

  def self.included(clazz)
    clazz.extend(Macros)
  end

  module Macros

    def acts_as_something(options = {})
      extend ClassMethods
      include InstanceMethods

      configuration = {:something => 'something'}
      configuration.update(options) if options.is_a?(Hash)

      define_method(:something_value) do
        puts "#{configuration[:something]}"
      end

      # callback into instance method?
    end

  end

  module ClassMethods

    def class_method
      puts 'class_method'
    end

  end

  module InstanceMethods

    def instance_method
      puts 'instance_method'
    end

  end

end

class MyClass
  include ActsAsSomething
  acts_as_something :something => 'rock on'
end

MyClass.class_method
MyClass.new.something_value
MyClass.new.instance_method

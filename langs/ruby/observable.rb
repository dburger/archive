# simple observable for Ruby, see design patterns in Ruby for more / better
# variations

module Observable

 def add_observer(observer = nil, &block)
   observers << (observer || block)
 end

 def remove_observer(observer)
   observers.delete(observer)
 end

 def notify_observers(*args)
   observers.dup.each {|o| o.is_a?(Proc) ? o.call(*args) : o.update(*args)}
 end

 private

 def observers
   @observers ||= []
 end

end

class Tester
 include Observable
 def doit
   notify_observers
 end
end

# exploits method_missing
class XmlBduiler

 def initialize(out)
   @out = out
 end

 def content(text)
   @out << text.to_s
   nil
 end

 def comment(text)
   @out << "<!-- #{text} -->"
   nil
 end

 def tag(name, attrs = {})
   @out << "<#{name}"
   attrs.each {|key, val| @out << " #{key}='#{val}'"}

   if block_given?
     @out << '>'
     if content = yield
       @out << content.to_s
     end
     @out << "></#{name}>"
   else
     @out << "/>"
   end
 end

 alias_method :method_missing, :tag

 def self.generate(out, &block)
   new(out).instance_eval(&block)
 end

end 

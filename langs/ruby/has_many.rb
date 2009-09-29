#!/usr/bin/env ruby -w

module Something

  class Base

    def self.has_many(*args)
      args.each do |arg|
        define_method(arg) do
          puts arg.to_s
        end
      end
    end

  end

end

class RobotChicken < Something::Base

  has_many :chicklets

end

rc = RobotChicken.new
rc.chicklets



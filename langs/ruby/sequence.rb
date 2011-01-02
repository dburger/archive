#!/usr/bin/env ruby

def run_odometer(digits, base)
  odometer = Array.new(digits, 0)
  yield odometer
  high_value = base - 1
  digit = max_digit = digits - 1
  while digit > -1 do
    if odometer[digit] < high_value
      odometer[digit] += 1
      digit = max_digit
      yield odometer
    else
      odometer[digit] = 0
      digit -= 1
    end
  end
end

values = ['unknown', 'yes', 'no', 'maybe']

run_odometer(6, values.length) do |o|
  puts o.map {|i| "'#{values[i]}'"}.join(', ')
end

run_odometer(3, 10) do |o|
  puts o.inspect
end

# def generate_sequence(arr, num)
#   counter = Array.new(num, 0)
#   hi = arr.length - 1
#   pos = max_pos = counter.length - 1
#   yield counter
#   while pos > -1 do
#     if counter[pos] < hi
#       counter[pos] += 1
#       pos = max_pos
#       yield counter
#     else
#       counter[pos] = 0
#       pos -= 1
#     end
#   end
# end

# generate_sequence(['yes', 'no', 'maybe'], 4) do |s|
#   puts s.inspect
# end

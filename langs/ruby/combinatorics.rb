class Combinatorics

  # nPr index permutation lexicographic order.
  def self.next_permutation(a)
    # find largest subscript j with a[j] < a[j + 1]
    j = a.length - 2
    while a[j] > a[j + 1] do
      j -= 1
    end

    # find the largest subscript k with a[k] < a[j]
    k = a.length - 1
    while a[j] > a[k] do
      k -= 1
    end

    # swap them
    a[j], a[k] = a[k], a[j]

    # put the tail of the permutation in increasing order
    r = a.length - 1
    s = j + 1
    while r > s do
      a[r], a[s] = a[s], a[r]
      r -= 1
      s += 1
    end

    a
  end

  # Yields nPr index permutation lexicographic order.
  def self.generate_permutations(length)
    curr_perm = (0...length).to_a
    last_perm = curr_perm.reverse
    while curr_perm != last_perm do
      yield curr_perm
      curr_perm = next_permutation(curr_perm)
    end
    yield curr_perm
  end

  # this is perms with replacement that I started experimenting with
  # the new code is below
  # def run_odometer(digits, base)
  #   odometer = Array.new(digits, 0)
  #   yield odometer
  #   high_value = base - 1
  #   digit = max_digit = digits - 1
  #   while digit > -1 do
  #     if odometer[digit] < high_value
  #       odometer[digit] += 1
  #       digit = max_digit
  #       yield odometer
  #     else
  #       odometer[digit] = 0
  #       digit -= 1
  #     end
  #   end
  # end


  # nPr with replacement index permutation lexicographic order.
  def self.next_permutation_with_replacement(perm, n)
    high_value = n - 1
    digit = perm.length - 1
    while digit > -1
      if perm[digit] < high_value
        perm[digit] += 1
        return perm
      else
        perm[digit] = 0
        digit -= 1
      end
    end
    raise ArgumentError.new('Illegal permutation state.')
  end

  # Yields nPr with replacement index permutation lexicographic order.
  def self.generate_permutations_with_replacement(n, r)
    curr_perm = Array.new(r, 0)
    last_perm = Array.new(r, n - 1)
    while curr_perm != last_perm do
      yield curr_perm
      curr_perm = next_permutation_with_replacement(curr_perm, n)
    end
    yield curr_perm
  end

  # nCr index combination lexicographic order.
  def self.next_r_combination(a, n)
    r = a.length
    i = r - 1
    while a[i] == n - r + i do
      i -= 1
    end

    a[i] += 1

    (i + 1...r).each do |j|
      a[j] = a[i] + j - i
    end

    a
  end

  # Yields nCr index combination lexicographic order.
  def self.generate_r_combinations(n, r)
    curr_comb = (0...r).to_a
    last_comb = (n - r...n).to_a
    while curr_comb != last_comb
      yield curr_comb
      curr_comb = next_r_combination(curr_comb, n)
    end
    yield curr_comb
  end

end

puts 'generate all permutations of length 3'
Combinatorics.generate_permutations(3) {|p| puts p.inspect}

puts 'generate all permutations of length 2 with replacement from 3 items'
Combinatorics.generate_permutations_with_replacement(3, 2) {|p| puts p.inspect}

puts 'generate all combinations of 5 choose 2'
Combinatorics.generate_r_combinations(5, 2) {|c| puts c.inspect}

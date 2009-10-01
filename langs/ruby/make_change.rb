def make_change(money)
  coins = [100, 25, 10, 5, 1]
  money = (money * 100).to_i
  coins.inject([]) {|m, c| m.push(money / c); money %= c; m}
end

function makeChange(money) {
    var coins = [100, 25, 10, 5, 1];
    var output = [];
    money *= 100;
    for (var i = 0; i < coins.length; i++) {
        output.push(Math.floor(money / coins[i]));
        money %= coins[i];
    }
    return output;
}

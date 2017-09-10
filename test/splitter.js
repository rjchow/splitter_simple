var Splitter = artifacts.require("./Splitter.sol");
const expectThrow = require('./utils').expectThrow


contract('Splitter', function(accounts) {
  account_alice = accounts[0];
  account_bob = accounts[1];
  account_carol = accounts[2];
  account_eve = accounts[9];

  it("should have the Alice's address as the owner of the contract", function () { 
    return Splitter.deployed().then(function(instance) {
      return instance.alice();
    }).then(function(alice) {
      assert.equal(alice, account_alice, "Alice's address is not the owner's address")
    })
    
  });

  it("should allow Alice to set Bob and Carol's addresses", function() { 
    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      return splitter.setBobAddress(account_bob, {from: account_alice});
    }).then(function(){
      return splitter.bob();
    }).then(function (return_bob) {
      assert.equal(return_bob, account_bob)
    }).then(function () {
      return splitter.setCarolAddress(account_carol, {from: account_alice})
    }).then(function() {
      return splitter.carol.call();
    }).then(function (return_carol) {
      assert.equal(return_carol, account_carol)
    }); 

  });

  it("should not allow Eve to set Bob and Carol's addresses", function() {
    return Splitter.deployed().then(function(instance) {
      return expectThrow(splitter.setCarolAddress(account_carol, {from: account_eve}))
    })
  });

  it("should accept payment from Alice only", function() {
    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      return instance.alice();
    })
    .then(function(alice) {
      return splitter.sendTransaction({from: account_alice, to: splitter.address, value: 1000000})
    }).then(function(txReceipt) {
      return expectThrow(splitter.sendTransaction({from: account_eve, to: splitter.address, value: 1000000}))
    })
  });

  it("should have the correct split for an even value", function() {
    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      return instance.alice();
    })
    .then(function(alice) {
      transferValue = 1000000
      return splitter.sendTransaction({from: account_alice, to: splitter.address, value: transferValue})
    }).then(function(txReceipt) {
      return splitter.getBalance(account_bob);
    }).then(function (bob_balance) {
      assert.equal(bob_balance, 1000000) // because of previous test remaining value
      return splitter.getBalance(account_carol);
    }).then(function (carol_balance) { 
      assert.equal(carol_balance, 1000000)
    })
  });

  it("should have the correct split for an odd value", function() {
    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      return instance.alice();
    })
    .then(function(alice) {
      transferValue = 17
      return splitter.sendTransaction({from: account_alice, to: splitter.address, value: transferValue})
    }).then(function(txReceipt) {
      return splitter.getBalance(account_bob);
    }).then(function (bob_balance) {
      assert.equal(bob_balance, 1000008)
      return splitter.getBalance(account_carol);
    }).then(function (carol_balance) { 
      assert.equal(carol_balance, 1000008)
    }).then(function () {
      return splitter.getBalance(account_alice);
    }).then(function (alice_balance) {
      assert.equal(alice_balance, 1)
    })
  });


  it("should allow Bob and Carol to withdraw", function() {
    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      return splitter.withdrawBalance({from: account_bob});
    }).then(function() {
      return splitter.getBalance(account_bob);
    }).then(function(bob_balance) {
      assert.equal(bob_balance, 0)
    })
  });

  it("should not allow Eve to withdraw", function() {
    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      return expectThrow(splitter.withdrawBalance({from: account_eve}));
  });



});
});

  /* Reference Material

  it("should put 10000 MetaCoin in the first account", function() {
    return MetaCoin.deployed().then(function(instance) {
      return instance.getBalance.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    });
  });
  it("should call a function that depends on a linked library", function() {
    var meta;
    var metaCoinBalance;
    var metaCoinEthBalance;

    return MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(accounts[0]);
    }).then(function(outCoinBalance) {
      metaCoinBalance = outCoinBalance.toNumber();
      return meta.getBalanceInEth.call(accounts[0]);
    }).then(function(outCoinBalanceEth) {
      metaCoinEthBalance = outCoinBalanceEth.toNumber();
    }).then(function() {
      assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpected function, linkage may be broken");
    });
  });
  it("should send coin correctly", function() {
    var meta;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return meta.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return meta.sendCoin(account_two, amount, {from: account_one});
    }).then(function() {
      return meta.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return meta.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();

      assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
    });
  });
*/

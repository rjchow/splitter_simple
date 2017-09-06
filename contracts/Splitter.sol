pragma solidity ^0.4.4;


/*
Splitter Contract (Simple)
This contract receives an amount of ether from a sender, and splits it 
evenly between two other recipients.

It should:
 1. Have a sender address, Alice's address
 2. Have two recipients addresses, Bob and Carol's addresses
 3. Have two balance accounts, one each for Bob and Carol
 4. Have functions for paying out to Bob or Carol
 5. Have getter functions for all the balances
 6. Have a payable function for receiving ether from Alice
 7. Emit an event whenever Alice sends ether to the contract
 8. Emit an event whenever the contract pays out ether
 9. Emit an event whenever payment fails 

Unhappy Paths:
 a. A sender who isn't Alice sends ether to the contract -> throw
 b. Sends to Bob or Carol fails -> set flag for refund mode and allow Alice to retrieve refund
*/

contract Splitter {
	mapping (address => uint) balances;
	address Alice;
	address Bob;
	address Carol;


/* Reference material

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	function MetaCoin() {
		balances[tx.origin] = 10000;
	}

	function sendCoin(address receiver, uint amount) returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getBalanceInEth(address addr) returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) returns(uint) {
		return balances[addr];
	}
*/

}

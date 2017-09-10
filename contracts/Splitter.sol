pragma solidity ^0.4.4;


/*
Splitter Contract (Simple)
This contract receives an amount of ether from a sender, and splits it 
evenly between two other recipients.

It should:
 1. Have a sender address, Alice's address (Owner's address)
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
	address public alice;
	address public bob;
	address public carol;

	uint public alice_balance;
	uint public bob_balance;
	uint public carol_balance;

	mapping (address => uint) public balances;

	event LogWithdrawal(address withdrawer, uint amount);

	function () payable {
		require(msg.sender == alice);
		require(msg.value > 0);

		uint half = msg.value / 2;

		balances[bob] += half;
		balances[carol] += half;
		
		if (msg.value % 2 == 1) {
			balances[alice] += 1;
		}
	}


	function Splitter(address recipient_bob, address recipient_carol) {
		alice = msg.sender;

	}

	function getBalance(address person) 
		constant 
		returns (uint256) 
	{
		return balances[person];
	}

	function setBobAddress(address recipient_bob) {
		require(msg.sender == alice);
		bob = recipient_bob;
	}

	function setCarolAddress(address recipient_carol) {
		require(msg.sender == alice); 
		carol = recipient_carol;
	}

	function withdrawBalance() {
		require(balances[msg.sender] > 0);

		uint amount_withdrawn = balances[msg.sender];
		balances[msg.sender] = 0;

		msg.sender.transfer(amount_withdrawn); // if transfer fails the transaction is reverted
		LogWithdrawal(msg.sender, amount_withdrawn);
	}

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

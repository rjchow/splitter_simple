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
 b. Sends to Bob or Carol fails -> revert transaction
*/

contract Splitter {
	address public alice;
	address public bob;
	address public carol;

	mapping (address => uint) public balances;

	event LogWithdrawal(address withdrawer, uint amount);

	function Splitter() {
		alice = msg.sender;
	}

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
}
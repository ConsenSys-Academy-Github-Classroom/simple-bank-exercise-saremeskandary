/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {
    /* State variables
     */

    mapping(address => uint256) internal balances;

    mapping(address => bool) public enrolled;

    address public owner = msg.sender;

    /* Events - publicize actions to external listeners */

    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint256 amount);

    event LogWithdrawal(address accountAddress, uint256 withdrawAmount, uint256 newBalance);

    /* Functions
     */

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract

    // TODO fallback or function?
    function() external payable {
        revert();
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }


    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;

        emit LogEnrolled(msg.sender);

        return enrolled[msg.sender];
    }


    function deposit() public payable returns (uint256) {
        require(enrolled[msg.sender] == true);
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, balances[msg.sender]);
        return balances[msg.sender];
    }

    function withdraw(uint256 withdrawAmount) public payable returns (uint256) {
        require(balances[msg.sender] >= withdrawAmount);
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
    }
}

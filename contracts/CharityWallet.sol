// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

contract CharityWallet {
    address public owner;
    address public charityAddress;
    uint256 public charityPercentage;

    event Deposited(address indexed from, uint256 amount, uint256 charityAmount);
    event Withdrawal(address indexed to, uint256 amount);

    constructor(address _charityAddress, uint256 _charityPercentage) {
        owner = msg.sender;
        charityAddress = _charityAddress;
        charityPercentage = _charityPercentage;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        // Calculate charity amount
        uint256 charityAmount = (msg.value * charityPercentage) / 100;
        
        // Send charity amount to charity address
        payable(charityAddress).transfer(charityAmount);
        
        // Emit event for deposit
        emit Deposited(msg.sender, msg.value, charityAmount);
    }

    function withdraw(uint256 _amount) public onlyOwner {
        require(_amount > 0 && _amount <= address(this).balance, "Invalid withdrawal amount");
        
        // Transfer requested amount to owner
        payable(owner).transfer(_amount);
        
        // Emit event for withdrawal
        emit Withdrawal(msg.sender, _amount);
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
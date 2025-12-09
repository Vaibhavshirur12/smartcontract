// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MySecureBank {
    mapping(address => uint256) private walletBalance;

    event MoneyAdded(address indexed user, uint256 amount);
    event MoneyTaken(address indexed user, uint256 amount);
    event MoneySent(address indexed sender, address indexed receiver, uint256 amount);

    // Add Ether to your bank wallet
    function addFunds() external payable {
        require(msg.value != 0, "Amount cannot be zero");
        walletBalance[msg.sender] = walletBalance[msg.sender] + msg.value;
        emit MoneyAdded(msg.sender, msg.value);
    }

    // Take out Ether from your bank wallet
    function takeFunds(uint256 amount) external {
        uint256 currentBalance = walletBalance[msg.sender];
        require(amount > 0, "Invalid amount");
        require(currentBalance >= amount, "Not enough funds");

        walletBalance[msg.sender] = currentBalance - amount;
        payable(msg.sender).transfer(amount);
        emit MoneyTaken(msg.sender, amount);
    }

    // Send Ether balance internally to another user of the contract
    function sendFunds(address receiver, uint256 amount) external {
        require(receiver != address(0), "Receiver cannot be zero address");
        require(amount > 0, "Invalid amount");
        require(walletBalance[msg.sender] >= amount, "Balance too low");

        walletBalance[msg.sender] -= amount;
        walletBalance[receiver] += amount;
        emit MoneySent(msg.sender, receiver, amount);
    }

    // Check how much balance you are holding
    function checkFunds() external view returns (uint256) {
        return walletBalance[msg.sender];
    }
}

// Get funds from user
// Withdraw funds
// Set a minimum funding amount in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

// Only works with Rinkeby Testnet
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    // Just like wallet holds funds, the contracts can also hold funds
    // Payable makes the function to be called with certain value i.e. native token which is ETH in this case
    function fund() public payable {
        // set a minimum fund limit
        // value called with a function can be accessed by msg.value 
        // at least 1 ETH
        // if the first expression is false in require, then it reverts
        // revert means undo any actions before and send the remaining gas back
        // require(getConversionRate(msg.value) >= minimumUSD, "Didn't send enough funds..."); // 1e18 = 1 * 10 ** 18 = 1000000000000000000
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough funds..."); // 1e18 = 1 * 10 ** 18 = 1000000000000000000
        // msg.sender gives the address of the caller
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        // There are three ways to transfer the funds
        // The `transfer` and `send` has got some issues. Refer: https://solidity-by-example.org/sending-ether
        // 1. Transfer
        // To transfer, first we need to cast the sender's address to payable address
        // `this` means the current instance of the contract
        // payable(msg.sender).transfer(address(this).balance);

        // 2. Send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed...");

        // 3. Call
        (bool callSuccess, /* bytes memory dataReturned */) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "Sender is not owner!");
        if (msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    // what happens if someone sends ETH to this contract without calling fund function

    // receive
    // receive is called when someone calls the contract with ETH without any data
    receive() external payable {
        fund();
    }

    // fallback
    // fallback is called when someone calls the contract with ETH and with or without any data
    // fallback is also called if there's no receive function defined
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()
    fallback() external payable {
        fund();
    }

}

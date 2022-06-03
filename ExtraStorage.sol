// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage {

    // For a function to be overridable, we need to declare it as a virtual function 
    // It means that the definition of store function in SimpleStorage should look like this:
    // function store(uint256 _favoriteNumber) public virtual {}
    // while overriding a method, we need to add override keyword as shown below
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }

}

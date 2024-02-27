// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract Counter {
    // State variable to store the counter's value
    uint256 private _number;

    // Event declaration (optional, for logging the number's value changes)
    event NumberChanged(uint256 newValue);

    // Function to set the counter's number
    function setNumber(uint256 newNumber) public {
        _number = newNumber;
        emit NumberChanged(_number); // Log the number change
    }

    // Function to increment the counter by 1
    function increment() public {
        _number += 1;
        emit NumberChanged(_number); // Log the number change
    }

    // Function to get the current counter's number
    function number() public view returns (uint256) {
        return _number;
    }
}

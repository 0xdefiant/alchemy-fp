// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src//MultisigWallet.sol"; // Adjust the import path based on your project structure

contract MultisigWalletTest is Test {
    MultisigWallet public multisigWallet;
    address[] public owners;
    uint public required = 2;

    function setUp() public {
        // Initialize with a list of owners and a requirement for how many signatures are needed
        owners.push(address(this)); // Adding the test contract itself as an owner for simplicity
        owners.push(address(0x1)); // Example owner address
        multisigWallet = new MultisigWallet(owners, required);

        // Sending ETH to the multisig wallet to cover transaction fees (if necessary)
        payable(address(multisigWallet)).transfer(1 ether);
    }

    function testSubmitTransactionAsOwner() public {
        // Attempt to submit a transaction as an owner (the test contract itself in this setup)
        address to = address(0x2); // Example recipient address
        uint value = 0.1 ether;
        bytes memory data = ""; // Assuming no data for simplicity

        // Since the test contract is an owner, this should succeed
        multisigWallet.submitTransaction(to, value, data);
    }

    function testFailSubmitTransactionAsNonOwner() public {
        // Attempt to submit a transaction as a non-owner
        vm.prank(address(0x3)); // Forge's way to simulate a call from another address
        address to = address(0x2); // Example recipient address
        uint value = 0.1 ether;
        bytes memory data = ""; // Assuming no data for simplicity

        // This should fail due to the onlyOwner modifier
        multisigWallet.submitTransaction(to, value, data);
    }

    // Helper function to fund the contract for gas fees, etc.
    receive() external payable {}
}

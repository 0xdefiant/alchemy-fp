// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

// import {console2} from "forge-std/console2.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract MultisigWallet {
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private owners;

    uint public required;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint confirmations;
    }

    // find attestation tooling in the eth.attestation library
    // struct Attestation {

    // }

    // struct PaymentIn {
    //     address from;
    //     uint value;
    //     enum goodOrService;
    //     bytes data;
    //     bool attested;
    //     uint attestations;
    // }

    // PaymentIn[] public paymentIn;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public isConfirmed; // is a transaction confirmed

    modifier onlyOwner() {
        require(isOwner(msg.sender), "caller is not an owner");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required");
        require(_required > 0 && _required <= _owners.length, "invalid required number of owners");

        for (uint i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "invalid owner");
            require(!owners.contains(_owners[i]), "owner not unique");

            owners.add(_owners[i]);
        }

        required = _required;
    }

    function isOwner(address account) public view returns (bool) {
        return owners.contains(account);
    }

    event SubmitTransaction(address indexed owner, uint indexed txIndex, address indexed to, uint value, bytes data);
    function submitTransaction(address _to, uint _value, bytes calldata _data) external onlyOwner {
        uint txIndex = transactions.length;
        
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
        }));
        
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    function approveTransaction(uint _txIndex) external onlyOwner {
        require(_txIndex < transactions.length, "tx does not exist");
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        
        transactions[_txIndex].confirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
        
        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    event ExecuteTransaction(address indexed owner, uint indexed txIndex);
    function executeTransaction(uint _txIndex) external onlyOwner {
        require(_txIndex < transactions.length, "tx does not exist");
        Transaction storage transaction = transactions[_txIndex];
        
        require(!transaction.executed, "tx already executed");
        // require(transaction.confirmations >= required || isVendorConfirmed[transaction.to], "cannot execute tx");
        require(transaction.confirmations >= required, "cannot execute");

        transaction.executed = true;
        (bool success,) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "tx failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    // function receivePayment(enum _goodOrService) external payable {
    //     emit PaymentReceived();
    //     // make the amount of money in this funciton public
        
    // }

    event Deposit(address indexed sender, uint value);
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}

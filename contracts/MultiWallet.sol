// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract MultiWallet {
    uint public numConfirm; // Number of confirmations required for executing a transaction
    address[] public owners; // Array of wallet owners

    struct Transaction {
        address to; // Recipient address of the transaction
        uint value; // Amount of Ether to be sent in the transaction
        bool executed; // Flag indicating whether the transaction has been executed
    }

    mapping (uint => mapping (address => bool)) isConfirmed; // Mapping to track confirmations for each transaction
    mapping (address => bool) isOwner; // Mapping to track wallet ownership

    Transaction[] public transactions; // Array to store all transactions

    event TxSubmitted(uint transactionId, address sender, address receiver, uint amount); // Event emitted when a transaction is submitted
    event TxConfirmed(uint transactionId); // Event emitted when a transaction is confirmed
    event TxExecuted(uint transactionId); // Event emitted when a transaction is executed

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Error, you are not an owner"); // Modifier to restrict access to only wallet owners
        _;
    }

    constructor(address[] memory _owners, uint _numConfirmationRequired) {
        require(_owners.length > 1, "There must be at least more than two owners"); // Ensure there are at least two owners
        require(_numConfirmationRequired > 0 && _numConfirmationRequired <= _owners.length, "The number of confirmations does not equal the number of owners"); // Ensure numConfirm is within valid range
        numConfirm = _numConfirmationRequired; // Set the number of confirmations required
        
        // Initialize wallet owners and ownership mapping
        for(uint i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid Owner"); // Ensure owner address is not null
            owners.push(_owners[i]); // Add owner to the owners array
            isOwner[_owners[i]] = true; // Set the owner's mapping to true
        }
    }

    /**
     * @dev Submits a transaction to the contract.
     * @param _to The recipient address of the transaction.
     */
    function submitTX(address _to) public payable {
        require(_to != address(0), "invalid"); // Ensure recipient address is valid
        require(msg.value > 0, "It must be greater than 0"); // Ensure value sent is greater than 0
        uint transactionId = transactions.length; // Obtain the transaction ID
        
        // Create a new transaction and push it to the transactions array
        transactions.push(Transaction({
            to: _to,
            value: msg.value,
            executed: false
        }));

        emit TxSubmitted(transactionId, msg.sender, _to, msg.value); // Emit TxSubmitted event
    }

    /**
     * @dev Confirms a transaction by an owner.
     * @param _transactionId The ID of the transaction to be confirmed.
     */
    function confirmTx(uint _transactionId) public onlyOwner {
        require(_transactionId < transactions.length, "Invalid transaction"); // Ensure valid transaction ID
        require(!isConfirmed[_transactionId][msg.sender],"Transaction is already confirm by owner"); // Ensure owner has not already confirmed
        
        isConfirmed[_transactionId][msg.sender] = true; // Mark the transaction as confirmed by the owner
        emit TxConfirmed(_transactionId); // Emit TxConfirmed event
        
        if(isTransactionConfirmed(_transactionId)) { // Check if transaction is confirmed by required number of owners
            executeTx(_transactionId); // Execute the transaction
        }
    }
    
    /**
     * @dev Checks if a transaction is confirmed by the required number of owners.
     * @param _transactionId The ID of the transaction to be checked.
     * @return Whether the transaction is confirmed or not.
     */
    function isTransactionConfirmed(uint _transactionId) public view returns (bool) {
        require (_transactionId < transactions.length, "Invalid Transaction"); // Ensure valid transaction ID
        uint confirmation = 0; // Initialize confirmation count
        
        // Iterate through owners and count confirmations
        for(uint i = 0; i < numConfirm; i++) {
            if(isConfirmed[_transactionId][owners[i]]) { // Check if owner has confirmed
                confirmation++; // Increment confirmation count
            }
        }
        return confirmation >= numConfirm; // Return true if confirmed by required number of owners
    }

    /**
     * @dev Executes a transaction.
     * @param _transactionId The ID of the transaction to be executed.
     */
    function executeTx(uint _transactionId) public payable {
        require(_transactionId < transactions.length, "Invalid transaction"); // Ensure valid transaction ID
        require(!transactions[_transactionId].executed, "Transaction is already executed"); // Ensure transaction not already executed
        
        // Execute the transaction by sending Ether to the recipient
        (bool success,) = transactions[_transactionId].to.call{value:transactions[_transactionId].value}("");
        require(success, "Transaction Execution Failed "); // Ensure transaction execution was successful
        
        transactions[_transactionId].executed = true; // Mark the transaction as executed
        emit TxExecuted(_transactionId); // Emit TxExecuted event
    }
}

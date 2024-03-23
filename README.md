// # MultiWallet Contract
//
// This contract implements a multi-signature wallet allowing multiple owners to confirm and execute transactions.
// Owners can submit transactions and confirm them, and once a transaction reaches the required number of confirmations,
// it can be executed by any owner. The contract ensures that only authorized owners can interact with it.
//
// ## Functions
//
// - `submitTX(address _to)`: Allows an owner to submit a transaction to the specified address.
//   @dev Requires a non-zero value to be sent along with the transaction.
//   @notice This function submits a transaction to the specified recipient address with the provided amount.
//
// - `confirmTx(uint _transactionId)`: Allows an owner to confirm a pending transaction by its ID.
//   @dev Once the required number of confirmations is reached, the transaction can be executed.
//   @notice This function confirms a pending transaction identified by its transaction ID.
//
// - `isTransactionConfirmed(uint _transactionId)`: Checks if a transaction has received the required number of confirmations.
//   @dev Returns true if the number of confirmations is equal to or greater than the required number.
//   @notice This function checks if a transaction identified by its ID has received the required number of confirmations.
//
// - `executeTx(uint _transactionId)`: Executes a confirmed transaction by its ID.
//   @dev Transfers the specified amount to the recipient address.
//   @notice This function executes a confirmed transaction identified by its ID, transferring the specified amount to the recipient address.
//
// ## Events
//
// - `TxSubmitted(uint transactionId, address sender, address receiver, uint amount)`: 
//   Emitted when a transaction is submitted, providing details such as sender, receiver, and amount.
//
// - `TxConfirmed(uint transactionId)`: 
//   Emitted when a transaction is confirmed by an owner.
//
// - `TxExecuted(uint transactionId)`: 
//   Emitted when a transaction is executed after reaching the required number of confirmations.

# MultiWallet Smart Contract

## Overview
This Solidity smart contract implements a multi-signature wallet system where transactions require confirmation from multiple owners before being executed. Each owner can submit transactions and confirm transactions initiated by other owners. Once a transaction receives the required number of confirmations, it can be executed to transfer Ether to the specified recipient.

## Features
- Allows multiple owners to manage a single wallet.
- Transactions require a configurable number of confirmations from owners before execution.
- Events are emitted for transaction submission, confirmation, and execution.
- Prevents duplicate confirmations and execution of transactions.
- Provides functions to submit transactions, confirm transactions, and execute transactions.

## Contract Structure
- `numConfirm`: Number of confirmations required for executing a transaction.
- `owners`: Array of wallet owners' addresses.
- `Transaction`: Struct representing a transaction with recipient address, value, and execution status.
- `isConfirmed`: Mapping to track confirmations for each transaction.
- `isOwner`: Mapping to track wallet ownership.
- `transactions`: Array to store all transactions.
- `TxSubmitted`, `TxConfirmed`, `TxExecuted`: Events emitted for transaction lifecycle.
- `onlyOwner`: Modifier to restrict access to wallet owners.
- `constructor`: Initializes the contract with owners and confirmation requirements.
- `submitTX`: Function to submit a transaction to the contract.
- `confirmTx`: Function to confirm a transaction by an owner.
- `isTransactionConfirmed`: Function to check if a transaction is confirmed by the required number of owners.
- `executeTx`: Function to execute a transaction.

## Usage
1. Deploy the contract with an array of owner addresses and the number of confirmations required.
2. Owners can submit transactions using the `submitTX` function.
3. Owners can confirm pending transactions using the `confirmTx` function.
4. Once a transaction receives the required confirmations, any owner can execute it using the `executeTx` function.

## Deployment
This contract should be deployed on a compatible Ethereum Virtual Machine (EVM) such as Ethereum mainnet, testnets, or private Ethereum networks.

## Note
- Ensure that owner addresses are correctly initialized during contract deployment.
- Adjust the number of confirmations required based on the desired security level.
- Exercise caution when executing transactions, as they involve transferring Ether.

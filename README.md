# Report on-chain Toolkit demo site

This is a fork of a Safe Multi-sig wallet that emits events that mark the completion of a transaction, and can function as a reporting tool for businesses.
-----------------
The contracts for the Multisig are in the `contracts` folder in `src` and the tests in `tests`

### This wallet functions as a companies bank, internal controls, and auditing services. It is however best implimented if it can be applied on a private network, but with event subscriptions that mimic financial statements.

# Workflow of Incoming Transactions
When the wallet received a payment to the receivePayment function, it enters a pool of unverified transactions called `paymentIn`.
- These payments need to be signed by an external auditor
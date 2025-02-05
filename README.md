# My First DAO project!

## Description and main key points of this project.
DAO (Decentralized Autonomous Organization) is a digital structure that uses blockchain technology to allow its members to make decisions collectively. DAOs are often called "crypto-cooperatives" or "financial flashmobs".

This DAO repo has these key points:
1. We are going to have a contract controlled by a DAO
2. Every transaction that the DAO wants to send has to be voted
3. Using ERC20 tokens for voting (just as first project)
4. This will not be deployed in a real testnet.

## Technologies Used
- **Solidity**: Smart contract programming language.
- **Foundry**: A powerful development environment for Ethereum.
- **Forge**: Used for writing and running tests.

## The src (source) folder:

- Has an DaoBox contract which
-  imports Ownable from Openzeppelin and inherits it,
-  it has an constructor passing an address initialOwner as a type variable and passes the initialOwner in parameters from the Ownable constructor,
-  its has an number in storage, it has an event that represents the change of an number,
-  it has a function that stores this number, takes an uint256 newNumber as parameter and uses the onlyOwner modifier from Ownable contract, it updates the number to a new number and then emits an event that the number has been updated. --it also has an view function that returns the newNumber to see if it has changed.
- 
- Has an DaoGovToken contract which
- imports ERC20, ERC20Permit and ERC20Votes from Openzeppelin,
-  has an constructor which takes the ERC20 and ERC20Permit parameters to make the name of my ERC20 token,
- It has functions like mint, burn to mint and burn our tokens and some functions from erc20permit and votes to update the state after an token is transfered and a function to return the nonces.
- 
- Has an TimeLock contract which
- imports TimeLockController from Openzeppelin and
- has an constructor that has some type varaibles as parameters and also pass the TimeLockController and it's parameters in our constructor.
- 
- Has an myGov contract
- It is mostly copied from the governance contract from openzeppelin and most of the functions also
- It has function to vote, update the state of the proposal
- Functions to store operations and execute them also

## Tests:
-The project contains only tests of the MyGov contract functions
- It has functions to:
- See if you can't update the box without governance.
- See if the governance updates the box contract

  ## Libraries:
  This repository uses:
  Forge-std from Foundry
  Openzeppelin-contracts from Openzeppelin

  ## Inspiration
  This whole repo is inspired on Cyfrin governance lessons!

  ##License:
  MIT
- 


# SolahParchiThap (SPT)

SolahParchiThap (SPT) is a decentralized game built on the Ethereum blockchain. It allows players to participate in a multiplayer game where they can join a pool, play their turns, pass tokens (known as "Parchi"), and compete to be the first to complete a set of tokens.

This repository contains the smart contract code for the SPT game, along with a React frontend to interact with the smart contract.

## Smart Contract

The smart contract code is written in Solidity, a programming language specifically designed for smart contracts on the Ethereum platform. It defines the game rules, player interactions, and manages the game state. The smart contract is deployed on the Sepolia testnet at address [0xb4ffbaa78ae83c1f6775e8f0652c3a5c343d750b](https://sepolia.etherscan.io/address/0xb4ffbaa78ae83c1f6775e8f0652c3a5c343d750b).

## Frontend

The frontend of the SPT game is built using React, a popular JavaScript library for building user interfaces. It provides a user-friendly interface for players to interact with the smart contract. The frontend communicates with the smart contract using Web3.js, a JavaScript library that interacts with the Ethereum blockchain.

## Installation

To run the SPT game locally on your machine, follow these steps:

1. Clone this repository: `git clone https://github.com/sauravrao637/spt.git`
2. Navigate to the project directory: `cd spt/client`
3. Install the dependencies: `npm install`
4. Start the development server: `npm start`
5. Open your browser and visit `http://localhost:3000` to access the SPT game.

Please note that you will need a compatible Ethereum wallet (like MetaMask) to connect to the Sepolia testnet or deploy the smart contract to another network.

## How to Play

1. Join the Game: Enter your name and click the "Join" button to join the game pool.
2. Wait for Players: Wait for other players to join the game pool. Once there are four players, the game can be started.
3. Start the Game: Any player in pool can start the game by clicking the "Start Game" button.
4. Play Turns: Take turns playing the game by passing tokens (Parchi) and trying to complete a set.
5. Objective: Player has to collect 4 similar tokens (Parchi). The first one to do so can claim win.
6. Claim Win: If you believe you have completed a set, you can click the "Claim Win" button to claim your victory.
7. Game Over: Once a player has claimed the win, the game is over, and the winner is displayed.
8. NOTE: Owner of the contract can reset the game if required.

## Contributing

Contributions and suggestions to the SPT project are welcome! If you have any bug fixes, improvements, or new features to propose, please submit a pull request. For major changes, please open an issue first to discuss the changes you would like to make.

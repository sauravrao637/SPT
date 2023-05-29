import React, { Component } from 'react';
import Web3 from 'web3';
import './App.css';
import { SPT_ABI, SPT_Address } from './config';

class SolahParchiThapGame extends Component {
  constructor(props) {
    super(props);
    this.state = {
      contract: null,
      players: [],
      currentPlayer: '',
      playerParchi: [],
      playerName: '',
      parchiIndex: '',
      gameInProgress: false,
    };
  }

  async componentDidMount() {
    await this.loadWeb3();
    await this.loadContract();
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      await window.ethereum.enable();
      const web3 = window.web3;

      // Get the current selected account
      const accounts = await web3.eth.getAccounts();
      const selectedAccount = accounts[0];

      // Update the state with the selected account
      this.setState({ account: selectedAccount });

      await this.fetchGameState();
    } else {
      window.alert("Please install MetaMask to use this application!");
    }
  }


  async loadContract() {
    const web3 = window.web3;
    const contract = new web3.eth.Contract(SPT_ABI, SPT_Address);
    this.setState({ contract });
  }

  async fetchGameState() {
    const { contract } = this.state;
    if (!contract) return;

    const players = await contract.methods.getPool().call();

    const turn = await contract.methods.turn().call();
    const gameInProgress = turn != 4
    var currentPlayer;
    try {
      currentPlayer = await contract.methods.getTurn().call();
    } catch (error) {
      console.error(error)
      currentPlayer = 'Start Game'
    }

    const playerParchi = await contract.methods
      .showParchi()
      .call({ from: window.ethereum.selectedAddress });
    console.log(gameInProgress)
    this.setState({ players, currentPlayer, playerParchi, gameInProgress });
  }


  joinGame = async () => {
    const { contract, playerName } = this.state;
    if (contract && playerName) {
      try {
        await contract.methods.enterPool(playerName).send({
          from: window.ethereum.selectedAddress,
        });
        await this.fetchGameState();
      } catch (error) {
        console.error('Error joining the game:', error);
      }
    }
  };

  startGame = async () => {
    const { contract, } = this.state;
    try {
      await contract.methods.startGame().send({ from: window.ethereum.selectedAddress });
      // Game started successfully
    } catch (error) {
      console.error(error);
      // Handle error during game start
    }
    this.fetchGameState()
  };


  passParchi = async () => {
    const { contract, parchiIndex } = this.state;
    if (contract && parchiIndex !== '') {
      try {
        await contract.methods.passParchi(parchiIndex).send({
          from: window.ethereum.selectedAddress,
        });
        await this.fetchGameState();
      } catch (error) {
        console.error('Error passing parchi:', error);
      }
    }
  };

  claimWin = async () => {
    const { contract } = this.state;
    if (contract) {
      try {
        await contract.methods.claimWin().send({
          from: window.ethereum.selectedAddress,
        });
        await this.fetchGameState();
      } catch (error) {
        console.error('Error claiming win:', error);
      }
    }
  };

  isPlayerInPool = async () => {
    const result = await this.contract.methods.amIinPool();

    return result;
  };

  render() {
    const {
      players,
      currentPlayer,
      playerParchi,
      playerName,
      parchiIndex,
      gameInProgress
    } = this.state;

    const isPlayerInPool = true
    const isPoolFull = players.length === 4;
    console.log({ isPlayerInPool, isPoolFull })

    return (
      <div>
        <h1>SolahParchiThap Game</h1>
        <h2>Players:</h2>
        <ul>
          {players.map((player, index) => (
            <li key={index}>{player}</li>
          ))}
        </ul>
        <h2>Current Player: {currentPlayer}</h2>
        <h2>Your Parchi Tokens:</h2>
        <ul>
          {playerParchi.map((parchi, index) => (
            <li key={index}>{parchi}</li>
          ))}
        </ul>
        {
          players && players.length < 4 &&
          <div>
            <h3>Join the Game:</h3>
            <input
              type="text"
              value={playerName}
              onChange={(e) =>
                this.setState({ playerName: e.target.value })
              }
              placeholder="Enter your name"
            />
            <button onClick={this.joinGame}>Join</button>
          </div>
        }
        <div>
          <h3>Pass a Parchi Token:</h3>
          <input
            type="number"
            value={parchiIndex}
            onChange={(e) =>
              this.setState({ parchiIndex: e.target.value })
            }
            placeholder="Enter parchi index"
          />
          <button onClick={this.passParchi}>Pass</button>
        </div>
        <div>
          <h3>Claim Win:</h3>
          <button onClick={this.claimWin}>Claim Win</button>
        </div>

        {gameInProgress ? (
          <h1>Game in progress</h1>
        ) : isPlayerInPool && isPoolFull ? (
          <button onClick={this.startGame}>Start Game</button>
        ) : (
          <h1>Waiting for players to join...</h1>
        )}

      </div>
    );
  }
}

export default SolahParchiThapGame;

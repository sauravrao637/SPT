// SPDX-License-Identifier: GPL-3.0-only
// Author:- @sauravrao637
// https://sepolia.etherscan.io/address/0xb4ffbaa78ae83c1f6775e8f0652c3a5c343d750b
// 0xb4ffbaa78ae83c1f6775e8f0652c3a5c343d750b
pragma solidity ^0.8.10;


contract SolahParchiThap{
    address payable public owner;

    uint8 public turn = 4;
    bool win = false;
    uint256 entryFee = 10000 wei;
    
    struct Player{
        address payable walletAdd;
        string name;
        uint[] myParchi;
    }

    uint8 private totalPlayers = 0;
    Player[4] private pool;

    function getPool() public view returns(string[] memory){
        string[] memory players = new string[](totalPlayers);
        for (uint i = 0; i < totalPlayers; i++) {
            players[i] = pool[i].name;
        }
        return players;
    }

    
    event PlayerEntered(string name);
    event GameStarted();
    event Turn(string name);
    event ParchiTransfer(string from, string to);
    event PlayerWon(string name);
    event GameOver();

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not the owner");
        _;
    }
    
    modifier onlyPlayers(){
        bool isPlayer = false;
        for(uint i=0; i<totalPlayers; i++){
            if (msg.sender == pool[i].walletAdd) {
                isPlayer = true;
                break;
            }
        }
        require(isPlayer, "Not a player");
        _;
    }

    function getStringLength(string memory str) public pure returns (uint256) {
        bytes memory strBytes = bytes(str);
        return strBytes.length;
    }
    
    function enterPool(string memory name) payable public {
        // Check of the pool has space
        require(totalPlayers < 4, "Pool is full");
        require(getStringLength(name) <10, "Name too big");
        require(msg.value == entryFee, "Entry fee should be 10000 wei");

        // Check the player is not already in pool
        for(uint i=0; i<totalPlayers; i++){
            require(keccak256(abi.encodePacked(name)) != keccak256(abi.encodePacked(pool[i].name)), "IGN already in use");
            require(msg.sender != pool[i].walletAdd, "Player already in pool");
        }

        Player memory newPlayer = Player(payable(msg.sender), name, new uint[](0));
        pool[totalPlayers] = newPlayer;
        totalPlayers+=1;
        emit PlayerEntered(name);
    }

    function shuffleArrayUint(uint[] memory arr) private view {
        uint n = arr.length;
        for (uint i = 0; i < n; i++) {
            uint256 randIndex = i + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, i))) % (n - i);
            uint256 temp = arr[randIndex];
            arr[randIndex] = arr[i];
            arr[i] = temp;
        }
    }

    function shufflePool() private {
        for (uint256 i = 0; i < 4; i++) {
            uint256 randIndex = i + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, i))) % (4 - i);
            Player memory temp = pool[randIndex];
            pool[randIndex] = pool[i];
            pool[i] = temp;
        }
    }

    function shuffleAndDistribute() private {
        uint[] memory integers = new uint[](16);
        for (uint i = 0; i < 16; i++) {
            integers[i] = i;
        }
        shuffleArrayUint(integers);

        shufflePool();

        for (uint i = 0; i < 4; i++) {
            for (uint j = 0; j < 4; j++) {
                uint index = i * 4 + j;
                pool[i].myParchi.push(integers[index]);
            }
        }
    }

    function startGame() public onlyPlayers {
        require(totalPlayers == 4, "Pool not full");
        require(turn == 4, "Game is already in progress");
        shuffleAndDistribute();
        // Set turn to first player
        turn = 0;
        emit GameStarted();
        emit Turn(pool[turn].name);
    }

    function getNext() private view returns(uint8) {
        return (turn+1)%4;
    }

    function giveParchi(uint index) private onlyPlayers {
        require(pool[turn].myParchi.length >=4, "Can't give");
        require(index < pool[turn].myParchi.length, "Invalid index");

        for (uint256 i = index; i < pool[turn].myParchi.length - 1; i++) {
            pool[turn].myParchi[i] = pool[turn].myParchi[i + 1];
        }
        pool[turn].myParchi.pop();
    }

    function recieveParchi(uint parchiIndex) private onlyPlayers{
        uint8 n = getNext();
        pool[n].myParchi.push(parchiIndex);
        turn = n;
        emit Turn(pool[n].name);
    }

    function passParchi(uint parchi) public onlyPlayers {
        require(pool[turn].walletAdd == msg.sender, "Not your turn :/");
        require(parchi >=0 && parchi < pool[turn].myParchi.length, "What the heck!?");

        uint parchiIndex = pool[turn].myParchi[parchi];
        string memory from = pool[turn].name;
        giveParchi(parchi);
        recieveParchi(parchiIndex);

        emit ParchiTransfer(from, pool[turn].name);
    }

    function claimWin() public onlyPlayers returns(string memory winner){
        require(pool[turn].walletAdd == msg.sender, "Not your turn");
        require(pool[turn].myParchi.length >= 4, "Not four");
        uint x = pool[turn].myParchi[0]/4;
        uint y = pool[turn].myParchi[1]/4;
        uint ans = 1;
        
        if(x == y) ans+=1;

        for(uint i = 2; i< pool[turn].myParchi.length; i++){
            uint z = pool[turn].myParchi[i]/4;
            if(x == z)ans+=1;
            else if(y ==z) ans+=1;    
        }
        require(ans>=4, "Not Four");
        win = true;
        winner = pool[turn].name;
        emit PlayerWon(winner);
        pool[turn].walletAdd.transfer(3*entryFee);
        owner.transfer(entryFee);
        endGame();
    } 

    function endGame() private{
        win = false;
        turn = 4;
        totalPlayers = 0;
        emit GameOver();
    }

    function showParchi() public onlyPlayers view returns(uint[] memory aray ) {
        for(uint i = 0; i< 4;i++){
            if(pool[i].walletAdd == msg.sender){
                aray = pool[i].myParchi;
                break;
            }
        }
    }

    function amIinPool() public view returns(bool){
        for(uint i=0; i<totalPlayers; i++){
            if (msg.sender == pool[i].walletAdd) {
                return true;
            }
        }
        return false;
    }
    
    function myName() public view onlyPlayers returns(string memory name){
        name = "";
        for(uint i=0; i<totalPlayers; i++){
            if (msg.sender == pool[i].walletAdd) {
                name = pool[i].name;
                break;
            }
        }
    }

    function getTurn() public view returns(string memory name) {
        require(turn!=4, "Start Game");
        name = pool[turn].name;
    }

    function forceEndGame() public onlyOwner {
        endGame();
    }
}


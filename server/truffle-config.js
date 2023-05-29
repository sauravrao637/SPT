module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545, // Ganache GUI port (default is 7545) or 8545 for Ganache CLI
      network_id: "*" // Match any network id
    }
  },

  compilers: {
    solc: {
      version: "0.8.10", // Specify the desired Solidity version here
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};

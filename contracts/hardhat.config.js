require("hardhat-kontour");

module.exports = {
  solidity: "0.8.11",
  paths: {
    sources: "./ethereum",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  networks: {
    rinkeby: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [`${process.env.ROPSTEN_PRIVATE_KEY}`],
    },
  },
};

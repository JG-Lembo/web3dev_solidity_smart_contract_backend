require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: "0.8.0",
  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/lFwqcXSp2RGh9ZKv_CSFdSCt38t3-8IT",
      accounts: [process.env.GOERLI_PRIVATE_KEY],
    },
  },
};
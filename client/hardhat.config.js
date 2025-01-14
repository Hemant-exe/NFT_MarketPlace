require("@nomicfoundation/hardhat-toolbox");

const NEXT_PUBLIC_SEPOLIA_RPC="";
const NEXT_PUBLIC_PRIVATE_KEY="";


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  // defaultNetwork:"eth",
  // networks:{
  //   hardhat:"",
  //   eth_sepolia: {
  //     url: NEXT_PUBLIC_SEPOLIA_RPC,
  //     accounts: [`0x${NEXT_PUBLIC_PRIVATE_KEY}`],
  //   },
  // },
};

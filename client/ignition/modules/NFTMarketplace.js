const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("NFTMarketplaceModule", (m) => {
  
  const marketplace = m.contract("NFTMarketplace", []);

  return { marketplace };
});

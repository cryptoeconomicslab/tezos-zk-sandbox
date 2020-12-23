const main = artifacts.require("main");
const mainStorage = require("../storage/main");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(main, mainStorage);
  const mainInstance = await main.deployed();
  console.log(`main address: ${mainInstance.address}`);
};

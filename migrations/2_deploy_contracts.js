var MedProduct = artifacts.require("MedProduct");

module.exports = function(deployer) {
  deployer.deploy(MedProduct);
};
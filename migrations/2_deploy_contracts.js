const Visitor = artifacts.require("Visitor");

module.exports = function (deployer) {
    deployer.deploy(Visitor, { from: "0x5e4efedf3d71232340280d8bc475421352994b63" });
};

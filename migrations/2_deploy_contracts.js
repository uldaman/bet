const Visitor = artifacts.require("Visitor");
const UintList = artifacts.require("UintList");

module.exports = function (deployer) {
    deployer.deploy(UintList, { from: "0x5e4efedf3d71232340280d8bc475421352994b63" });
    deployer.link(UintList, Visitor);
    deployer.deploy(Visitor, { from: "0x5e4efedf3d71232340280d8bc475421352994b63" });
};

var Migrations = artifacts.require("Migrations.sol");

module.exports = function (deployer) {
    deployer.deploy(Migrations, { from: "0x5e4efedf3d71232340280d8bc475421352994b63" });
};

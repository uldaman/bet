pragma solidity >=0.4.24 <0.6.0;

import "./Ownable.sol";
import "./Struct.sol";


contract Manager is Ownable {
    address[] public managers;

    modifier onlyManager() {
        require(isManager(msg.sender), "Not Manager");
        _;
    }

    function isManager(address manager) private view returns (bool) {
        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == manager) {
                return true;
            }
        }
        return false;
    }

    function addManager(address manager) public onlyOwner {
        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == manager) {
                return;
            }
        }
        managers.push(manager);
    }

    function removeManager(address manager) public onlyOwner {
        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == manager) {
                delete managers[i];
                return;
            }
        }
    }
}

pragma solidity >=0.4.24 <0.6.0;

import "./Ownable.sol";
import "./Struct.sol";


contract Manager is Ownable {
    address[] public managers;
    mapping (address => uint) public royalty;
    uint public numOfManages;


    modifier onlyManager() {
        require(isManager(msg.sender), "Not Manager");
        _;
    }

    function isManager(address manager) private view returns (bool) {
        if(owner == manager) {
            return true;
        }

        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == manager) {
                return true;
            }
        }
        return false;
    }

    function updateRoyalty(uint wage) internal {
        for(uint i = 0; i < managers.length; i++) {
            address manager = managers[i];
            if(manager != address(0)) {
                royalty[manager] = royalty[manager] + wage;
            }
        }
    }

    function addManager(address manager) public onlyOwner {
        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == manager) {
                return;
            }
        }
        managers.push(manager);
        numOfManages++;
    }

    function removeManager(address manager) public onlyOwner {
        for(uint i = 0; i < managers.length; i++) {
            if(managers[i] == manager) {
                delete managers[i];
                numOfManages--;
                return;
            }
        }
    }
}

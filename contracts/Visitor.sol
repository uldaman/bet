pragma solidity >=0.4.24 <0.6.0;

import "./Player.sol";

contract Visitor is Player {
    function getLeftTotalPledge(uint _id) public view returns(uint) {
        return quizs[_id].totalPledge[left];
    }

    function getRightTotalPledge(uint _id) public view returns(uint) {
        return quizs[_id].totalPledge[right];
    }
}

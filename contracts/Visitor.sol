pragma solidity >=0.4.24 <0.6.0;

import "./Player.sol";

contract Visitor is Player {
    function getLeftTotalPledgeByGameId(uint _id) public view returns(uint) {
        return quizs[_id].totalPledge[left];
    }

    function getRightTotalPledgeByGameId(uint _id) public view returns(uint) {
        return quizs[_id].totalPledge[right];
    }

    function getPledgeByGameId(uint _id) public view returns(uint) {
        return quizs[_id].players[msg.sender].pledge;
    }

    function getOptionByGameId(uint _id) public view returns(uint) {
        return quizs[_id].players[msg.sender].option;
    }
}

pragma solidity >=0.4.24 <0.6.0;

import "./Player.sol";

contract Visitor is Player {
    function getQuizPledge(uint _id, uint option) public view returns(uint) {
        require(option == left || option == right, "Options can only be 1 or 2");
        return quizs[_id].totalPledge[option];
    }

    function getPlayerPledge(uint _id, uint option) public view returns(uint) {
        require(option == left || option == right, "Options can only be 1 or 2");
        return quizs[_id].players[msg.sender].pledge[option];
    }
}

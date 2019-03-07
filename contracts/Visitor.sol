pragma solidity >=0.4.24 <0.6.0;

import "./Player.sol";

contract Visitor is Player {
    function getQuizTotalPledgeByOption(uint _id, uint choice) public view returns(uint) {
        require(choice == left || choice == right, "Options can only be 1 or 2");
        return quizs[_id].totalPledge[choice];
    }

    function getQuizWinner(uint _id) public view returns(uint) {
        require(quizs[_id].stage == Stages.Finished, "Quiz must be finished");
        return quizs[_id].winner;
    }

    function getPlayerPledgeByOption(uint _id, uint choice) public view returns(uint) {
        require(choice == left || choice == right, "Options can only be 1 or 2");
        return quizs[_id].players[msg.sender].pledge[choice];
    }

    function isQuizActive(uint _id) public view returns (bool) {
        return quizs[_id].stage == Stages.Active;
    }

    function isQuizLocked(uint _id) public view returns (bool) {
        return quizs[_id].stage == Stages.Active;
    }

    function isQuizFinished(uint _id) public view returns (bool) {
        return quizs[_id].stage == Stages.Active;
    }

    function getPlayerQuizs() external view returns(uint[] memory) {
        uint[] memory result = new uint[](playerQuizs[msg.sender].count);
        uint counter = 0;
        for (uint i = playerQuizs[msg.sender].iterate_start()
        ;playerQuizs[msg.sender].iterate_valid(i)
        ;i = playerQuizs[msg.sender].iterate_next(i)) {
            result[counter] = playerQuizs[msg.sender].iterate_get(i);
            counter++;
        }
        return result;
    }
}

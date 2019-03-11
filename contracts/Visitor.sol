pragma solidity >=0.4.24 <0.6.0;

import "./Player.sol";

contract Visitor is Player {
    function getQuiz(uint _id) public view returns(
        uint id, Stages stage,
        string memory leftName, uint leftPledge,
        string memory rightName, uint rightPledge,
        uint winner
    ) {
        require(quizs[_id].stage != Stages.None, "Quiz not exited");
        Quiz storage quiz = quizs[_id];
        id = _id;
        stage = quiz.stage;
        leftName = quiz.leftName;
        rightName = quiz.rightName;
        winner = quiz.winner;
        leftPledge = quiz.totalPledge[left];
        rightPledge = quiz.totalPledge[right];
    }

    function getPlayerChoicePledge(uint _id, uint combatant) public view returns(uint) {
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        return quizs[_id].players[msg.sender].pledge[combatant];
    }
}

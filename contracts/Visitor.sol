pragma solidity >=0.4.24 <0.6.0;

import "./Player.sol";

contract Visitor is Player {
    function getQuiz(uint _id) public view returns(
        uint id, Stages stage,uint startTime, string memory gameName,
        string memory leftName, uint leftPledge, uint leftScore,
        string memory rightName, uint rightPledge,  uint rightScore
    ) {
        require(quizs[_id].stage != Stages.None, "Quiz not exited");
        Quiz storage quiz = quizs[_id];
        id = _id;
        stage = quiz.stage;
        startTime = quiz.startTime;
        gameName = quiz.gameName;

        Combatant storage left = quiz.combatants[left];
        Combatant storage right = quiz.combatants[right];

        leftName = left.name;
        leftPledge = left.totalPledge;
        leftScore = left.score;
        rightName = right.name;
        rightPledge = right.totalPledge;
        rightScore = right.score;
    }

    function getPlayerCombatantPledge(uint _id, uint combatant) public view returns(uint) {
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        return quizs[_id].combatants[combatant].pledges[msg.sender];
    }

    function getPlayerAward(uint _id) public view returns(uint) {
        Quiz storage quiz = quizs[_id];
        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        if (quiz.hasWithdraw[msg.sender]) {
            return 0;
        }
        return _award(_id);
    }
}

pragma solidity >=0.4.24 <0.6.0;

import "./Player.sol";

contract Visitor is Player {
    function getQuiz(uint _id) public view returns(
        uint id, Stages stage,
        string memory leftName, uint leftPledge, uint leftScore,
        string memory rightName, uint rightPledge,  uint rightScore
    ) {
        require(quizs[_id].stage != Stages.None, "Quiz not exited");
        Quiz storage quiz = quizs[_id];
        id = _id;
        stage = quiz.stage;

        Combatant storage left = quiz.combatants[left];
        Combatant storage right = quiz.combatants[right];

        leftName = left.name;
        leftPledge = left.pledge;
        leftScore = left.score;
        rightName = right.name;
        rightPledge = right.pledge;
        rightScore = right.score;
    }

    function getPlayerCombatantPledge(uint _id, uint combatant) public view returns(uint) {
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        return quizs[_id].combatants[combatant].players[msg.sender].pledge;
    }
}

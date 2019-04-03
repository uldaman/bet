pragma solidity >=0.4.24 <0.6.0;

import "./Manager.sol";
import "./Struct.sol";


contract Quiz is Manager, Struct {
    event _creat(uint indexed _id, string gameName, uint startTime, string leftName, string rightName);
    event _cancel(uint indexed _id);
    event _lock(uint indexed _id);
    event _finish(uint indexed _id, uint winner);

    function creat(uint _id, uint startTime, string memory gameName, string memory leftName, string memory rightName) public onlyManager {
        require(quizs[_id].stage == Stages.None, "Quiz already exists");
        quizs[_id].stage = Stages.Active;
        quizs[_id].startTime = startTime;
        quizs[_id].gameName = gameName;
        quizs[_id].combatants[left].name = leftName;
        quizs[_id].combatants[right].name = rightName;
        emit _creat(_id, gameName, startTime, leftName, rightName);
    }

    function cancel(uint _id) public onlyManager {
        require(quizs[_id].stage != Stages.Finished, "Quiz must not be finished");
        quizs[_id].stage = Stages.Canceled;
        emit _cancel(_id);
    }

    function lock(uint _id) public onlyManager {
        require(quizs[_id].stage == Stages.Active, "Quiz must be active");
        quizs[_id].stage = Stages.Locked;
        emit _lock(_id);
    }

    function finish(uint _id, uint letScore, uint rightScore) public onlyManager {
        Quiz storage quiz = quizs[_id];

        require(quiz.stage == Stages.Locked, "Quiz must be locked");
        quiz.stage = Stages.Finished;
        quiz.combatants[left].score = letScore;
        quiz.combatants[right].score = rightScore;

        updateRoyalty(_royalty(_id) / numOfManages);

        emit _finish(_id, _winner(_id));
    }

    function updateScore(uint _id, uint combatant, uint score) public onlyManager {
        require(quizs[_id].stage == Stages.Locked, "Quiz must be locked");
        quizs[_id].combatants[combatant].score = score;
    }

    function _royalty(uint _id) internal view returns (uint) {
        return _bonusPool(_id) / 1000;
    }

    function _bonusPool(uint _id) internal view returns (uint) {
        Quiz storage quiz = quizs[_id];
        return quiz.combatants[left].totalBet + quiz.combatants[right].totalBet;
    }

    function _winner(uint _id) internal view returns (uint) {
        Quiz storage quiz = quizs[_id];

        require(quiz.stage == Stages.Finished, "Quiz must be Finished");

        if (quiz.combatants[left].score > quiz.combatants[right].score) {
            return left;
        } else if (quiz.combatants[left].score < quiz.combatants[right].score) {
            return right;
        }

        return 0;
    }
}

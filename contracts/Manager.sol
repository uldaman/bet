pragma solidity >=0.4.24 <0.6.0;

import "./Struct.sol";

contract Manager is Struct {
    function creat(uint _id) public {
        require(quizs[_id].stage == Stages.None, "Quiz must be none");
        quizs[_id].stage = Stages.Activating;
    }

    function cancel(uint _id) public {
        require(quizs[_id].stage != Stages.Finished, "Quiz must not be finished");
        quizs[_id].stage = Stages.Canceled;
    }

    function lock(uint _id) public {
        require(quizs[_id].stage == Stages.Activating, "Quiz must be active");
        quizs[_id].stage = Stages.Locked;
    }

    function settle(uint _id, uint winner) public {
        Quiz storage quiz = quizs[_id];

        require(quiz.stage == Stages.Locked, "Quiz must be locked");
        require(winner == left || winner == right, "Winner can only be 1 or 2");

        quiz.stage = Stages.Finished;
        quiz.winner = winner;
    }
}

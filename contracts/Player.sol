pragma solidity >=0.4.24 <0.6.0;

import "./Manager.sol";

contract Player is Manager {
    function join(uint _id, uint option) public payable {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Activating, "Quiz must be active");
        require(option == left || option == right, "Voting options can only be 1 or 2");
        require(msg.value >= minStakes, "Pledge must be above the minimum");

        vote.pledge[option] = vote.pledge[option] + msg.value;
        quiz.totalPledge[option] = quiz.totalPledge[option] + msg.value;
    }

    function repent(uint _id, uint option) public {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Activating || quiz.stage == Stages.Canceled, "Quiz must be active or cancelled");
        require(option == left || option == right, "Voting options can only be 1 or 2");
        require(vote.pledge[option] != 0, "This option is not selected");

        uint stakes = vote.pledge[option];
        quiz.totalPledge[option] = quiz.totalPledge[option] - stakes;
        delete(vote.pledge[option]);
        msg.sender.transfer(stakes);
    }

    function withdraw(uint _id) public {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        require(!vote.hasWithdraw, "Has already withdrawed");
        require(vote.pledge[quiz.winner] > 0, "No option to win");

        uint totalAaward = quiz.totalPledge[left] + quiz.totalPledge[right];
        uint weight = vote.pledge[quiz.winner] / quiz.totalPledge[quiz.winner];
        uint award = totalAaward * weight;
        vote.hasWithdraw = true;
        msg.sender.transfer(award);
    }
}

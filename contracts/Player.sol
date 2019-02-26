pragma solidity >=0.4.24 <0.6.0;

import "./Manager.sol";

contract Player is Manager {
    function join(uint _id, uint option) public payable {
        Quiz storage quiz = quizs[_id];

        require(quiz.stage == Stages.Activating, "Quiz must be active");
        require(quiz.players[msg.sender].option == 0, "Already join this quiz");
        require(option == left || option == right, "Voting options can only be 1 or 2");
        require(msg.value >= minStakes, "Pledge must be above the minimum");

        quiz.players[msg.sender] = Vote(option, msg.value);
        quiz.totalPledge[option] = quiz.totalPledge[option] + msg.value;
    }

    function repent(uint _id) public {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Activating || quiz.stage == Stages.Canceled, "Quiz must be active or cancelled");
        require(vote.option != 0 && vote.pledge >= minStakes, "No bid");

        uint stakes = vote.pledge;
        delete(quiz.players[msg.sender]);
        msg.sender.transfer(stakes);
    }

    function withdraw(uint _id) public {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        require(vote.option != 0 && vote.pledge >= minStakes, "No bid");
        require(vote.option == quiz.winner, "Not winning the bid");

        uint totalAaward = quiz.totalPledge[1] + quiz.totalPledge[2];
        uint weight = vote.pledge / quiz.totalPledge[quiz.winner];
        uint award = totalAaward * weight;
        delete(quiz.players[msg.sender]);
        msg.sender.transfer(award);
    }
}

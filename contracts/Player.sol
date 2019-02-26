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

        require(vote.option != 0, "No bid");
        require(quiz.stage == Stages.Activating || quiz.stage == Stages.Canceled, "Quiz must be active or cancelled");

        uint stakes = vote.pledge;
        quiz.totalPledge[vote.option] = quiz.totalPledge[vote.option] - vote.pledge;
        delete(quiz.players[msg.sender]);
        msg.sender.transfer(stakes);
    }

    function withdraw(uint _id) public {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        require(vote.option == quiz.winner, "Not winning the quiz");

        uint totalAaward = quiz.totalPledge[left] + quiz.totalPledge[right];
        uint weight = vote.pledge / quiz.totalPledge[quiz.winner];
        uint award = totalAaward * weight;
        delete(quiz.players[msg.sender]);
        msg.sender.transfer(award);
    }
}

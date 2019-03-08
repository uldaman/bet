pragma solidity >=0.4.24 <0.6.0;

import "./Manager.sol";

contract Player is Manager {
    function join(uint _id, uint choice) public payable {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Active, "Quiz must be active");
        require(choice == left || choice == right, "Choice can only be 1 or 2");
        require(msg.value >= minStakes, "Pledge must be above the minimum");

        vote.pledge[choice] = vote.pledge[choice] + msg.value;
        quiz.totalPledge[choice] = quiz.totalPledge[choice] + msg.value;

        uint it = playerQuizs[msg.sender].find(_id);
        if (!playerQuizs[msg.sender].iterate_valid(it)) {
            playerQuizs[msg.sender].append(_id);
        }
    }

    function repent(uint _id, uint choice) public {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Active || quiz.stage == Stages.Canceled, "Quiz must be active or cancelled");
        require(choice == left || choice == right, "Choice can only be 1 or 2");
        require(vote.pledge[choice] != 0, "This choice is not selected");

        uint stakes = vote.pledge[choice];
        quiz.totalPledge[choice] = quiz.totalPledge[choice] - stakes;
        delete(vote.pledge[choice]);

        // uint it = playerQuizs[msg.sender].find(_id);
        // if (playerQuizs[msg.sender].iterate_valid(it)) {
        //     playerQuizs[msg.sender].remove(it);
        // }

        msg.sender.transfer(stakes);
    }

    function withdraw(uint _id) public {
        Quiz storage quiz = quizs[_id];
        Vote storage vote = quiz.players[msg.sender];

        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        require(!vote.hasWithdraw, "Has already withdrawed");
        require(vote.pledge[quiz.winner] > 0, "No choice to win");

        uint totalAaward = quiz.totalPledge[left] + quiz.totalPledge[right];
        uint weight = vote.pledge[quiz.winner] / quiz.totalPledge[quiz.winner];
        uint award = totalAaward * weight;
        vote.hasWithdraw = true;
        msg.sender.transfer(award);
    }
}

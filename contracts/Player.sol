pragma solidity >=0.4.24 <0.6.0;

import "./Manager.sol";

contract Player is Manager {
    event _join(uint indexed _id, address indexed player, uint combatant, uint stakes);
    event _repent(uint indexed _id, address indexed player, uint combatant, uint stakes);
    event _withdraw(uint indexed _id, address indexed player, uint award);

    function join(uint _id, uint combatant) public payable {
        Quiz storage quiz = quizs[_id];

        require(quiz.stage == Stages.Active, "Quiz must be active");
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        require(msg.value >= minStakes, "Pledge must be above the minimum");

        Combatant storage c = quiz.combatants[combatant];

        c.totalPledge = c.totalPledge + msg.value;
        c.pledges[msg.sender] = c.pledges[msg.sender] + msg.value;

        emit _join(_id, msg.sender, combatant, msg.value);
    }


    function repent(uint _id, uint combatant) public {
        Quiz storage quiz = quizs[_id];
        Combatant storage c = quiz.combatants[combatant];

        require(quiz.stage == Stages.Active || quiz.stage == Stages.Canceled, "Quiz must be active or cancelled");
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        require(c.pledges[msg.sender] != 0, "This combatant is not selected");

        uint stakes = c.pledges[msg.sender];
        c.totalPledge = c.totalPledge - stakes;
        c.pledges[msg.sender] = 0;
        msg.sender.transfer(stakes);

        emit _repent(_id, msg.sender, combatant, stakes);
    }

    function withdraw(uint _id) public {
        Quiz storage quiz = quizs[_id];
        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        require(!quiz.hasWithdraw[msg.sender], "Has already withdrawed");

        uint totalAaward = quiz.combatants[left].totalPledge + quiz.combatants[right].totalPledge;
        uint winner = _winner(_id);
        uint award;

        if (winner == left || winner == right) {
            award = totalAaward * quiz.combatants[winner].pledges[msg.sender] / quiz.combatants[winner].totalPledge;
        } else {
            award = quiz.combatants[left].pledges[msg.sender] + quiz.combatants[right].pledges[msg.sender];
        }

        quiz.hasWithdraw[msg.sender] = true;
        msg.sender.transfer(award);
        emit _withdraw(_id, msg.sender, award);
    }
}

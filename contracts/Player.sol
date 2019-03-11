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
        Vote storage v = c.players[msg.sender];

        c.pledge = c.pledge + msg.value;
        v.pledge = v.pledge + msg.value;

        emit _join(_id, msg.sender, combatant, msg.value);
    }

    function repent(uint _id, uint combatant) public {
        Quiz storage quiz = quizs[_id];
        Combatant storage c = quiz.combatants[combatant];
        Vote storage v = c.players[msg.sender];

        require(quiz.stage == Stages.Active || quiz.stage == Stages.Canceled, "Quiz must be active or cancelled");
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        require(v.pledge != 0, "This combatant is not selected");

        uint stakes = v.pledge;
        c.pledge = c.pledge - stakes;
        v.pledge = 0;
        msg.sender.transfer(stakes);

        emit _repent(_id, msg.sender, combatant, stakes);
    }

    function withdraw(uint _id) public {
        /// _winner 处理 0 的情况
        Quiz storage quiz = quizs[_id];
        Combatant storage w = quiz.combatants[_winner(_id)];
        Vote storage v = w.players[msg.sender];

        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        require(!v.hasWithdraw, "Has already withdrawed");
        require(v.pledge > 0, "No combatant to win");

        uint totalAaward = quiz.combatants[left].pledge + quiz.combatants[right].pledge;
        uint award = totalAaward * v.pledge / w.pledge;
        v.hasWithdraw = true;
        msg.sender.transfer(award);

        emit _withdraw(_id, msg.sender, award);
    }
}

pragma solidity >=0.4.24 <0.6.0;

import "./Quiz.sol";


contract Player is Quiz {
    event _join(uint indexed _id, address indexed player, uint combatant, uint stakes);
    event _repent(uint indexed _id, address indexed player, uint combatant, uint stakes);
    event _withdraw(uint indexed _id, address indexed player, uint award);

    function join(uint _id, uint combatant) public payable {
        Quiz storage quiz = quizs[_id];

        require(quiz.stage == Stages.Active, "Quiz must be active");
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        require(msg.value >= minStakes, "Bet must be above the minimum");

        Combatant storage c = quiz.combatants[combatant];

        c.totalBet = c.totalBet + msg.value;
        c.bets[msg.sender] = c.bets[msg.sender] + msg.value;

        emit _join(_id, msg.sender, combatant, msg.value);
    }


    function repent(uint _id, uint combatant) public {
        Quiz storage quiz = quizs[_id];
        Combatant storage c = quiz.combatants[combatant];

        require(quiz.stage == Stages.Active || quiz.stage == Stages.Canceled, "Quiz must be active or cancelled");
        require(combatant == left || combatant == right, "Combatant can only be 1 or 2");
        require(c.bets[msg.sender] != 0, "This combatant is not selected");

        uint stakes = c.bets[msg.sender];
        c.totalBet = c.totalBet - stakes;
        c.bets[msg.sender] = 0;
        msg.sender.transfer(stakes);

        emit _repent(_id, msg.sender, combatant, stakes);
    }

    function withdraw(uint _id) public {
        Quiz storage quiz = quizs[_id];
        require(quiz.stage == Stages.Finished, "Quiz must be finished");
        require(!quiz.hasWithdraw[msg.sender], "Has already withdrawed");

        uint award = _award(_id);
        quiz.hasWithdraw[msg.sender] = true;
        msg.sender.transfer(award);
        emit _withdraw(_id, msg.sender, award);
    }

    function _award(uint _id) internal view returns (uint) {
        Quiz storage quiz = quizs[_id];
        uint totalAaward = quiz.combatants[left].totalBet + quiz.combatants[right].totalBet;
        uint winner = _winner(_id);
        uint award;

        if (winner == left || winner == right) {
            award = totalAaward * quiz.combatants[winner].bets[msg.sender] / quiz.combatants[winner].totalBet;
        } else {
            award = quiz.combatants[left].bets[msg.sender] + quiz.combatants[right].bets[msg.sender];
        }

        return award;
    }
}

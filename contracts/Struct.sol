pragma solidity >=0.4.22 <0.6.0;

contract Struct {
    enum Stages {
        None,
        Active,
        Locked,
        Canceled,
        Finished
    }

    uint minStakes = 100 ether;
    uint constant left = 1;
    uint constant right = 2;

    struct Combatant {
        uint score;
        uint totalPledge;
        string name;
        mapping (address => uint) pledges;
    }

    struct Quiz {
        Stages stage;
        mapping (uint => Combatant) combatants; // combatant (left or right) => Combatant
        mapping (address => bool) hasWithdraw;
    }

    mapping (uint => Quiz) quizs;  // quiz id => quiz struct
}

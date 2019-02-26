pragma solidity >=0.4.22 <0.6.0;

contract Struct {
    enum Stages {
        None,
        Activating,
        Locked,
        Canceled,
        Finished
    }

    uint minStakes = 100 ether;
    uint constant left = 1;
    uint constant right = 2;

    struct Vote {
        mapping (uint => uint) pledge;  // option (left or right) => pledge
        bool hasWithdraw;
    }

    struct Quiz {
        Stages stage;
        uint winner;
        mapping (uint => uint) totalPledge;  // option (left or right) => total pledge
        mapping (address => Vote) players;
    }

    mapping (uint => Quiz) quizs;  // quiz id => quiz struct
}

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
    uint left = 1;
    uint right = 2;

    struct Vote {
        uint option;  // 0 没有参与, 1 left, 2 right
        uint pledge;
    }

    struct Quiz {
        Stages stage;
        uint winner;
        mapping (uint => uint) totalPledge;
        mapping (address => Vote) players;
    }

    mapping (uint => Quiz) quizs;  // quiz id => quiz struct
}

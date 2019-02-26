pragma solidity >=0.4.22 <0.6.0;

contract Struct {
    enum Stages {
        None,
        Activating,
        Locked,
        Canceled,
        Finished
    }

    struct Vote {
        uint option;  // 0 没有参与, 1 left, 2 right
        uint pledge;
    }

    struct Game {
        Stages stage;
        uint winner;
        mapping (uint => uint) totalPledge;
        mapping (address => Vote) players;
    }

    mapping (uint => Game) games;  // game id => game struct

    mapping (address => uint[]) playerGames;  // player => list of games
}

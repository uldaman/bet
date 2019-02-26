pragma solidity >=0.4.24 <0.6.0;

import "./Struct.sol";

contract Manager is Struct {
    uint public minStakes = 100 ether;

    function creat(uint _id) public {
        require(games[_id].stage == Stages.None, "Game must be none");
        games[_id].stage = Stages.Activating;
    }

    function cancel(uint _id) public {
        require(games[_id].stage != Stages.Finished, "Game must not be finished");
        games[_id].stage = Stages.Canceled;
    }

    function lock(uint _id) public {
        require(games[_id].stage == Stages.Activating, "Game must be active");
        games[_id].stage = Stages.Locked;
    }

    function settle(uint _id, uint winner) public {
        Game storage game = games[_id];

        require(winner == 1 || winner == 2, "Winner can only be 1 or 2");
        require(game.stage == Stages.Locked, "Game must be locked");

        game.stage = Stages.Finished;
        game.winner = winner;
    }
}

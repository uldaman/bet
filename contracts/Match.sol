pragma solidity >=0.4.24 <0.6.0;

import "./Manager.sol";

contract Match is Manager {
    function join(uint _id, uint option) public payable {
        Game storage game = games[_id];

        require(game.stage == Stages.Activating, "Game must be active");
        require(game.players[msg.sender].option == 0, "Already join this game");
        require(option == 1 || option == 2, "Voting options can only be 1 or 2");
        require(msg.value >= minStakes, "Pledge must be above the minimum");

        game.players[msg.sender] = Vote(option, msg.value);
        game.totalPledge[option] = game.totalPledge[option] + msg.value;
    }

    function repent(uint _id) public {
        Game storage game = games[_id];
        Vote storage vote = game.players[msg.sender];

        require(game.stage == Stages.Activating || game.stage == Stages.Canceled, "Game must be active or cancelled");
        require(vote.option != 0 && vote.pledge >= minStakes, "No bid");

        uint stakes = vote.pledge;
        delete(game.players[msg.sender]);
        msg.sender.transfer(stakes);
    }

    function withdraw(uint _id) public {
        Game storage game = games[_id];
        Vote storage vote = game.players[msg.sender];

        require(game.stage == Stages.Finished, "Game must be finished");
        require(vote.option != 0 && vote.pledge >= minStakes, "No bid");
        require(vote.option == game.winner, "Not winning the bid");

        uint totalAaward = game.totalPledge[1] + game.totalPledge[2];
        uint weight = vote.pledge / game.totalPledge[game.winner];
        uint award = totalAaward * weight;
        delete(game.players[msg.sender]);
        msg.sender.transfer(award);
    }
}

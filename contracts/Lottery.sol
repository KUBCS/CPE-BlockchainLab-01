// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Lottery {
    address public owner;
    address[] public players;
    uint256 public fee = 0.1 ether;


    constructor() {
        owner = msg.sender;
    }

    function enter() public payable {
        require(msg.value >= fee, "Not enough ether sent");
        players.push(msg.sender);
    }
    
    function pickWinner() public {
        require(msg.sender == owner, "Owner can pick winner only");
        require(players.length > 0, "No players in the lottery");

        uint256 winnerIndex = uint256(keccak256(abi.encodePacked(block.difficulty, 
        block.timestamp, players))) % players.length;

        address winner = players[winnerIndex];
        payable(winner).transfer(address(this).balance);

        players = new address[](0);
    }
}
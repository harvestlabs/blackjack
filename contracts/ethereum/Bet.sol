// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Bet {
    uint256 public betAmount;
    address payable public bettor;

    function bet() public payable {
        console.log("I'm betting this much: %s", msg.value);

        betAmount += msg.value;
        bettor = payable(msg.sender);
    }

    function payOut(bool playerWins) external returns (bool) {
        console.log("Game over, did the player win?: %s", playerWins);
        if (playerWins) {
            console.log("Transferring the player %s", address(this).balance);
            bettor.transfer(address(this).balance);
            return true;
        }
        console.log("Transferring the house %s", address(this).balance);
        return true;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Bet {
    uint256 betAmount;

    function bet(uint256 _bet) public {
        console.log("I'm betting this much: %s", _bet);

        betAmount = _bet;
    }

    function get() public view returns (uint256) {
        return betAmount;
    }
}


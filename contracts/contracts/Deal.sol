// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Deal {
    uint8[] CARDS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11];
    uint8[] dealerHand;
    uint8[] playerHand;
    uint8 public gameOver;
    address public betAddress;

    constructor(address _betAddress) {
        dealerHand = [10, 4];
        playerHand = [4, 8];
        gameOver = 0;
        betAddress = _betAddress;
    }

    function hitMe() public {
        console.log("Hit me called");
        uint8 card = selectCard();
        console.log("Dealing a random card: %s", card);

        emit CardDealt(card, false);
        playerHand.push(card);
        uint8 sum = 0;
        for (uint8 i = 0; i < playerHand.length; i+= 1) {
            sum += playerHand[i];
        }
        if (sum > 21) {
            endGame(21, sum);
        }
    }

    function selectCard() internal view returns (uint8) {
        uint256 rand = random();
        uint256 idx = rand % CARDS.length;
        return CARDS[idx];
    }

    function random() private view returns (uint256) {
        console.log("random called");
        return
            uint256(
                keccak256(abi.encodePacked(block.timestamp + block.number))
            );
    }

    function getDealerHand() public view returns (uint8[] memory) {
        return dealerHand;
    }

    function getPlayerHand() public view returns (uint8[] memory) {
        return playerHand;
    }

    function endGame(uint8 dealerSum, uint8 playerSum)
        internal
        returns (uint8 status)
    {
        console.log("dealer has %s", dealerSum);
        console.log("player has %s", playerSum);
        if (dealerSum > 21) {
            console.log("dealer went bust");
            emit GameOver(playerSum, dealerSum, true);
            return 1;
        }
        if (dealerSum >= 17) {
            bool playerWins = dealerSum < playerSum;
            console.log("playerWins: %s", playerWins);
            emit GameOver(playerSum, dealerSum, playerWins);

            if (playerWins) {
                return 1;
            }
            return 2;
        }
        return 0;
    }

    function playOut() public {
        console.log("playing out hand");
        uint8 sum = 0;
        uint8 playerSum = 0;
        for (uint8 i = 0; i < dealerHand.length; i += 1) {
            sum += dealerHand[i];
        }
        for (uint8 i = 0; i < playerHand.length; i += 1) {
            playerSum += playerHand[i];
        }
        if (sum <= 17) {
            console.log("Hit dealer called");
            uint8 card = selectCard();
            emit CardDealt(card, true);
            dealerHand.push(card);
            sum += card;
        }
        uint8 gameEnded = endGame(sum, playerSum);
        if (gameEnded != 0) {
            gameOver = 1;
            // TODO something with the bet distribution
            betAddress.call(
                abi.encodeWithSignature("payOut(bool)", gameEnded == 1)
            );
        }
    }

    event CardDealt(uint8 card, bool toDealer);
    event GameOver(uint8 playerScore, uint8 dealerScore, bool playerWins);
}

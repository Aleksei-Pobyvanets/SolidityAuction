//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";


pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";


contract Auction {

mapping (address => uint) public mappAuc;
mapping (address => uint) public playersValue;


struct AuctionSt {  
    address bettor;
    uint bettorAmount;
}


AuctionSt[] public auctions;


function addBet() payable public {
    address addr = msg.sender;
    uint amou = msg.value;

    AuctionSt memory newAuction = AuctionSt({
    bettor: addr,
    bettorAmount: amou
});

auctions.push(newAuction);

addBetter();
deleteLastPlayer();

}

uint public TotalValue = bal();
uint public LastBet;

function addBetter() payable public {

    require(msg.value >= 1000000000000000, "Minimum bet 0.01 Ether!");
    require(msg.value > LastBet, "Your bid must be greater than the previous one!");
    LastBet = msg.value;
    
    uint counter = mappAuc[msg.sender];
    require(counter < 3, "You spent all your shants!");

    
    uint payad = playersValue[msg.sender];
    uint totalPayPersom = payad + msg.value;
    
    counter = counter + 1;
    mappAuc[msg.sender] = counter;
 

    playersValue[msg.sender] = totalPayPersom;
    // TotalValue = bal();
}

function deleteLastPlayer() payable public {
    if(auctions.length > 2){
        address deletedBit = auctions[0].bettor;
        uint deletedBitAmount = auctions[0].bettorAmount;
        // uint amountToGive = playersValue[deletedBit];

        payable(deletedBit).transfer(deletedBitAmount);

        for (uint i = 0; i < auctions.length - 1; i++) {
        auctions[i] = auctions[i + 1];

        }
        auctions.pop();
    }
    
}
function Length() view public returns(uint){
    return auctions.length;
}

function mainAuc() payable public {

}
function bal() view public returns(uint){
    return address(this).balance;
}

} 

contract test {

    string[] public data;

    constructor() public {
        data.push(" John");
        data.push("Bruce");
        data.push("Tom");
        data.push("Bart");
        data.push("Cherry");
    }

    function removeIn0rder(uint index) external {
        for (uint i = index; i < data.length - 1; i++) {
        data[i] = data[i + 1];
        }
        data.pop();
        }
}
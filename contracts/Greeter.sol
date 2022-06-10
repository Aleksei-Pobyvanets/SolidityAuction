//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";


contract Auction {

mapping (address => uint) public mappAuc;
mapping (address => uint) public playersValue;


struct AuctionSt {  
    address bettor;
}


AuctionSt[] public auctions;


function addBet() payable public {
    address addr = msg.sender;

    AuctionSt memory newAuction = AuctionSt({
    bettor: addr
});

auctions.push(newAuction);

addBetter();
if(auctions.length > 2){
    deleteLastPlayer();
}

}

uint public TotalValue;
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
    TotalValue = TotalValue + msg.value;


}

function deleteLastPlayer() view public returns(address){
    for(uint i = 0; i < auctions.length; i++){
        AuctionSt memory _auc = auctions[i];
        return _auc.bettor;
    }
    
}

function mainAuc() payable public {

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
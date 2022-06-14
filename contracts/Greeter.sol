//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";


contract ERC20Token {
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "PobyvanetsToken";
    string public symbol = "POTO";
    uint public decimals = 2;

    function transfer(address recipient, uint amount) external returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }

    function approve(address spender, uint amount) external returns(bool){
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function buy() external payable {
        buyTokens(msg.sender);
    }

    function mint(uint amount) public {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
    }

    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0));
        uint256 weiAmount = msg.value;
        uint256 tokens = weiAmount*100;

        mint(tokens);
    }
}

// zzzzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzžzzzž

contract Auction is ERC20Token {

mapping (address => uint) public mappAuc;
mapping (address => uint) public playersValue;

uint start;
uint end;
bool public status = false;

struct AuctionSt {  
    address bettor;
    uint bettorAmount;
}

modifier timeIsOwer{
    require(block.timestamp <= end, "Timer is not works");
    _;
}

function startFunc(uint totalTime) public returns(bool){
    require(totalTime >= 15, "invalid value");
    require(status ==! true, "Already started");
    start = block.timestamp;
    end = totalTime + start;
    if(end == block.timestamp){
        return status = false;
    } else {
        return status = true;
    }
}
function getTimerLeft() public view timeIsOwer returns(uint){
    require(status , "Start timer");
    return end - block.timestamp;
}

function c() view public returns(uint){
    return decimals;
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
}

function deleteLastPlayer() payable public {
    if(auctions.length > 2){
        address deletedBit = auctions[0].bettor;
        uint deletedBitAmount = auctions[0].bettorAmount;

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
function bal() view public returns(uint){
    return address(this).balance;
}

} 
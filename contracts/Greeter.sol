//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";


contract ERC20Token {
    uint public totalSupply;
    mapping(address => uint)  balanceOf;
    mapping(address => mapping(address => uint))  allowance;
    string  name = "PobyvanetsToken";
    string  symbol = "POTO";
    uint  decimals = 2;

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

uint  start;
uint  end;
bool public status;
uint public totalTime;
address owner = msg.sender;
uint public bonus;

struct AuctionSt {  
    address bettor;
    uint bettorAmount;
}

modifier OnlyOwner{
    require(owner == msg.sender, "only owner!");
    _;
}

function endF(uint _val) external {
    
    require(totalTime <= 0, "Already started");
    uint val = _val;
    require(val > 15, "invalid value");

    totalTime = _val;
    status = true;
    start = block.timestamp;
    end = start + _val;
}

function getTimerLeft() public view returns(uint){
    return end - block.timestamp;
}

function addBet() payable external {
    require(status == true , "Start timer");

    if(end > block.timestamp){


            if(getTimerLeft() > 0){
            address addr = msg.sender;
            uint amou = msg.value;

            AuctionSt memory newAuction = AuctionSt({
            bettor: addr,
            bettorAmount: amou
            });

            auctions.push(newAuction);

            require(msg.value >= 1000000000000000, "Minimum bet 0.01 Ether!");
            require(msg.value > LastBet, "Your bid must be greater than the previous one!");
            LastBet = msg.value;
            calcBonus();
            
            uint counter = mappAuc[msg.sender];
            require(counter < 3, "You spent all your shants!");

            uint payad = playersValue[msg.sender];
            uint totalPayPersom = payad + msg.value;
            
            counter = counter + 1;
            mappAuc[msg.sender] = counter;
        
            playersValue[msg.sender] = totalPayPersom;

            deleteLastPlayer();

        }else{
            getReward();
        }  


    }else {
        status = false;
    }
    
}

AuctionSt[] public auctions;

uint public TotalValue = bal();
uint public LastBet;

function deleteLastPlayer() payable public {
    if(auctions.length > 5){
        address deletedBit = auctions[0].bettor;
        uint deletedBitAmount = auctions[0].bettorAmount;

        payable(deletedBit).transfer(deletedBitAmount);

        for (uint i = 0; i < auctions.length - 1; i++) {
            auctions[i] = auctions[i + 1];
        }
        auctions.pop();
    }
    
}
function bal() view public returns(uint){
    return address(this).balance - bonus;
}
function calcBonus() public{
    uint balamce = address(this).balance; 
    bonus = (balamce*1)/100;
}
function withdraw(address _addr) external payable OnlyOwner{
    payable(_addr).transfer(bonus);
    bonus = 0;
}
function getReward() public payable {
    if(end < block.timestamp){

        uint leng = auctions.length - 1;
        uint balamce = address(this).balance; 
        address deletedBit1 = auctions[leng].bettor;
        uint result = balamce - bonus;
        uint first = result / 2;
        uint second = (result*30)/100; 
        uint third = (result*20)/100;

        
        uint secUint = auctions.length - 2; 
        address deletedBit2 = auctions[secUint].bettor;
        
        uint secUint2 = auctions.length - 3;
        address deletedBit3 = auctions[secUint2].bettor;
        

        payable(deletedBit1).transfer(first);
        payable(deletedBit2).transfer(second);
        payable(deletedBit3).transfer(third);

        totalTime = 0;
        LastBet = 0;
        status = false;
        delete auctions;

    }else{
        revert();
    }     
}

} 
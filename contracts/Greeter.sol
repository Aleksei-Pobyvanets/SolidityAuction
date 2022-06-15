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

uint public start;
uint public end;
bool public status;
uint public totalTime;

struct AuctionSt {  
    address bettor;
    uint bettorAmount;
}

// modifier timeIsOwer{
//     require(block.timestamp < end, "Timer is not works");
//     _;
// }



function endF(uint _val) external {
    totalTime = _val;
    require(totalTime >= 15, "invalid value");
    start = block.timestamp;
    end = start + _val;
    status = true;
}



function getTimerLeft() public view returns(uint){
    return end - block.timestamp;
}

function addBet() payable  public {
    require(status == true , "Start timer");
    if(getTimerLeft() > 0){
        address addr = msg.sender;
            uint amou = msg.value;

            AuctionSt memory newAuction = AuctionSt({
            bettor: addr,
            bettorAmount: amou
            });

        auctions.push(newAuction);

        addBetter();
        deleteLastPlayer();
    }else{
        getReward();
    }   

    
}

AuctionSt[] public auctions;

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
function Length() view public returns(uint){
    return auctions.length;
}
function bal() view public returns(uint){
    return address(this).balance;
}
function getReward() public payable returns(address){
        uint leng = auctions.length;
        address deletedBit1 = auctions[leng].bettor;
        uint first = bal() / 2;

        
        uint secUint = leng - 1;
        address deletedBit2 = auctions[secUint].bettor;
        uint second = (30/bal())*bal();

        uint secUint2 = leng - 2;
        address deletedBit3 = auctions[secUint2].bettor;
        uint third = (20/bal())*bal();


        payable(deletedBit1).transfer(first);
        payable(deletedBit2).transfer(second);
        payable(deletedBit3).transfer(third);

}

function donate() public payable{

}

} 
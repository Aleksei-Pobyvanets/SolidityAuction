//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";

contract ScumToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("ScumToken", "SCT") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
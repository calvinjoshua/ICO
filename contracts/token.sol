pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract token is ERC20 {
    constructor() ERC20("alpha", "alp") {
        _mint(msg.sender, 100000000000000000000000000);
    }
}
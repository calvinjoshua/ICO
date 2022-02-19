pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract main{

    IERC20 public token;
    address payable owner;


    constructor(address _token) {
        token = IERC20(_token);
        owner = payable(msg.sender);

    }

    function transfer(address payable con, address payable to, uint256 amt) internal {
        bool sent = con.send(msg.value);
        require(sent, "Failed to send Ether");
        token.transfer(to, amt);
    }

    //Assuming tokens are transfered to the current(main.sol) contract, so inital tokens are transffered and contained in this contract (main.sol)
    //converted 0.01$ => ether, which is then represented in wei 
    function purchase(uint256 tokens) public payable{ //tokens to be mentioned in decimals of 10 power 18(Wei format)
        uint256 supply = token.totalSupply();
        uint256 totalAvailable = token.balanceOf(address(this)) ; 
        require(totalAvailable > 0, "Sold out");
        if(totalAvailable > (70000000000000000000 % supply )){
            require(msg.value == (tokens * 3600000000000), "not enought amount"); //0.0000036//inWei
            transfer(payable(owner),payable(msg.sender), tokens);
        }
        else if(totalAvailable < (70000000000000000000 % supply ) && totalAvailable >= (20000000000000000000 % supply )){ 
            require(msg.value == (tokens * 7300000000000), "not enought amount"); //0.0000073//inWei
            transfer(payable(owner),payable(msg.sender), tokens);
        } 
        else{
            uint256 p = (token.totalSupply() - token.balanceOf(address(this))/1000); 
            require(msg.value == (tokens * (p * 1000000000000000000)), "not enought amount"); //inWei
            transfer(payable(owner),payable(msg.sender), tokens);
        }
    }
}

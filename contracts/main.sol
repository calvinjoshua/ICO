pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract main{

    IERC20 public token;
    address payable owner;


    constructor(address _token) {
        token = IERC20(_token);
        owner = payable(msg.sender);
    }

    function transfer(address payable to, uint256 amt) internal {
        bool sent = owner.send(msg.value);
        require(sent, "Failed to transfer Ether");
        token.transfer(to, amt);
    }

    function purchase() public payable { //tokens to be mentioned in decimals of 10 power 18(Wei format)
        uint256 supply = token.totalSupply();
        uint256 totalAvailable = token.balanceOf(address(this)) ; 
        require(totalAvailable > 0, "Sold out");
        require(msg.value > 0, "0 INPUT");
        if(totalAvailable > (70000000000000000000 % supply )){
            uint256 tokens = msg.value / 3600000000000; //0.0000036 in wei
            transfer(payable(msg.sender), tokens);
        }
        else if(totalAvailable < (70000000000000000000 % supply ) && totalAvailable >= (20000000000000000000 % supply )){ 
            uint256 tokens = msg.value / 7300000000000; //0.0000073 in wei
            transfer(payable(msg.sender), tokens);
        } 
        else{
             /*
             finding how many tokens have been sold, making them into format of 7 decimals(since intial prices were 0.0000036 and 0.0000073) 
             converting them into 10 power 18 and calculating number of tokens according to msg.value
             */
            uint256 p = (token.totalSupply() - totalAvailable)/10000000;             
            uint256 tokens = msg.value / (p * 1000000000000000000);
            transfer(payable(msg.sender), tokens);
        }
    }
}
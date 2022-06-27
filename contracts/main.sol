pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract main{

    IERC20 public token;
    address payable owner;
    
    uint256 public phaseOnePrice = 3600000000000; //0.0000036
    uint256 public CurrentPrice = 7300000000000; //0.0000073 

    uint256 private phaseOneLimit = 70000000000000000000;
    uint256 private phaseTwoLimit = 20000000000000000000; 

    constructor(address _token) {
        require(_token != address(0), "Invalid Token Address");
        token = IERC20(_token);
        owner = payable(msg.sender);
    }

    event TokenPurchase(address buyer, uint256 amount, uint256 tokens);

    function transfer(address payable to, uint256 tokens, uint256 amt) internal {
        bool sent = owner.send(amt);
        require(sent, "Failed to transfer Ether");
        token.transfer(to, tokens);
    }

    function purchase() external payable { 
        uint256  totalAvailable = token.balanceOf(address(this)) ; 
        
        uint256 weiAmount = msg.value;
        uint256 tokens = 0;

        _validate(totalAvailable,msg.sender, weiAmount);

        if(totalAvailable > phaseOneLimit){
            _validate2(weiAmount, phaseOnePrice);//to check if user has enough msg.value to get minimum tokens
            tokens = weiAmount/ phaseOnePrice;
            transfer(payable(msg.sender), tokens, weiAmount);
        }
        else if(totalAvailable < phaseOneLimit && totalAvailable >= phaseTwoLimit){ 
            _validate2(weiAmount, CurrentPrice);
            tokens = weiAmount / CurrentPrice;  
            transfer(payable(msg.sender), tokens, weiAmount);
        } 
        /*
        after 80% of the tokens are sold, on each purchase, the phase two price (i.e CurretPrice) will be adding by value 0.000000000001. Eventually the last token's price will be 0.000027299 
        */
        else{
            CurrentPrice = CurrentPrice + 1000000; //0.000000000001
            _validate2(weiAmount, CurrentPrice);
            tokens = weiAmount / CurrentPrice ;
            transfer(payable(msg.sender), tokens, weiAmount );
        }
        
        emit TokenPurchase(msg.sender, weiAmount, tokens);
    }

    function _validate(uint256 _totalAvailable,address sender, uint256 amount) internal pure {
        require(sender != address(0), "Invalid Address");
        require(_totalAvailable > 0, "Sold out");
        require(amount != 0, "0 INPUT");
    }

    function _validate2(uint256 amt, uint256 price) internal pure {
        require(amt > price, "No enough amount"); //if the msg.value less the phaseOne price, then reverted
    }
    
}

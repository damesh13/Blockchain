// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import {priceConvert} from "./priceConvert.sol";

error can_not_process();

contract fundme{
    using priceConvert for uint256;
    address public immutable owner ;
    uint256 public constant  minimumAmount = 5e18;
    address[] public funders;
    mapping(address funder=> uint256 amount ) public amountAndFunder; 
    constructor() {
        owner =msg.sender;

    }

    modifier onlyowner{
        
        if (msg.sender != owner){revert can_not_process(); }
        _;
    }

    function fund() public payable {
        require(msg.value.getconvertamount() >= minimumAmount,"enter more than 1 Ether");
        funders.push(msg.sender);
        amountAndFunder[msg.sender] = amountAndFunder[msg.sender] + msg.value;
    }

    function withdraw() public onlyowner {

        for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex++){
            address funder = funders[funderIndex];
            amountAndFunder[funder] = 0;

        }
        funders=new address[](0);
        (bool success,)=payable(msg.sender).call{value:address(this).balance}("");
        require(success,"not successful ");


    }
    receive() external payable {
        fund();
     }
    fallback() external payable {
        fund();
     }
    
   
}
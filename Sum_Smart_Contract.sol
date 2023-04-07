// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; 
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract Sum
{

    uint256 Balance;
    uint256 a;
    uint256 b;
    uint fee;//default fee is 5
    bool payment=false;

    address public owner;

    constructor()public
    {
        owner=msg.sender;
        fee=5;
    }


    function store(uint256 num1,uint256 num2)public 
    {
        payment=false;
        a=num1;
        b=num2;
    }

    function storeFee(uint256 num)public
    {
        fee=num;
    }


    function CalculateSum() public payable returns(uint256)
    {
        //$5 is the minimum fee
        uint MinFee=fee*10**18;
        require(getConvRate(msg.value)>=MinFee,"Your Transaction is below the required fees;
        Balance+=msg.value;
        payment=true;

    }

    function GetSum()public view returns(uint256)
    {
        require(payment==true,"You must calculate the sum first!");
        return (a+b);
    }
    
    function withdraw()payable public
    {
        require(msg.sender==owner,"Only the Owner can withdraw!");
        msg.sender.transfer(address(this).balance);
        Balance=0;
    }

    function getbalance()public view returns(uint256)
    {
        return Balance;   //returns balance in wei
    }




    function getversion()private view returns(uint256)
    {
        AggregatorV3Interface pricefeed=AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return pricefeed.version();
    }

    function getprice()private view returns(uint256)
    {
        AggregatorV3Interface pricefeed=AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,)=pricefeed.latestRoundData();
        return uint256(answer*10000000000);
    }
    function getConvRate(uint256 ethAmount)private view returns(uint256)
    {
        uint256 ethPrice=getprice();
        uint256 ethUSD=(ethPrice*ethAmount)/1000000000000000000;
        return ethUSD;
    }



}


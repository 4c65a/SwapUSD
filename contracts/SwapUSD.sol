// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/** 
@title SwapUSD
@notice This smart contract is a basic swap usd/eth
@dev This smart contrac is build only for me learning.I am not an expert
*/

contract SwapUSD is Ownable{

  using SafeERC20 for IERC20;
  
  IERC20 public USDT;
  AggregatorV3Interface internal priceFeed;



  //@dev In this constructor inside the priceFeed, the address of USD/ETH (Chainlink) has to be included
  constructor(){
       priceFeed = AggregatorV3Interface();
  }



  /**
  @notice This function allows users to swap USD to ETH by first getting the latest USD/ETH price through the getLatestPrice function.
  @param _amount The amount of USD to be swapped to ETH
 */
  function swap(uint256 _amount)external {
    int256 etherPrice = getLatestPrice();
    uint256 etherAmount = uint256(etherPrice) * _amount / (10 ** 6);
    USDT.safeTransferFrom(msg.sender, address(this), _amount);
    payable(msg.sender).transfer(etherAmount);
    }


  /**
  @notice This function withdraws the ETH balance of the contract to the owner's address.
  @dev Only the contract owner can call this function.
  */
  function withdraw()external onlyOwner{
      uint256 balances = address(this).balance;
      payable(owner()).transfer(balances); 
  }

  /**
  @notice Receive ETH from the owner
  @dev Only the owner can call this function
  */
  receive() external payable onlyOwner{}

  /**
  @notice Get the balance of ETH held by this contract
  @dev Only the owner can call this function
  @return The balance of ETH held by this contract
  */
  function getBalanceETH()view public onlyOwner returns (uint256){
    return address(this).balance;
  }

  /**
  @notice Get the latest price of USD/ETH from Chainlink
  @return The latest price of USD/ETH as an integer
  */
   function getLatestPrice() public view returns (int) {
        (
           ,
            int price,
            ,
            ,
           
        ) = priceFeed.latestRoundData();
        return price;
    }


}


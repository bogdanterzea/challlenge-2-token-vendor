pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  uint256 public constant tokensPerEth = 100;

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amount = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, amount);
    emit BuyTokens(msg.sender, msg.value, amount);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() external {
    (bool success, ) = owner().call{value: address(this).balance}('');
    require(success, 'ERROR at withdrawing');
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount) external {
    // yourToken.transfer(owner(), amount);
    (bool success ) = yourToken.transferFrom(msg.sender, address(this), amount);
    require(success, 'Transfer failed');

    (bool payedSeller, ) = msg.sender.call{value: amount / tokensPerEth}('');
    require(payedSeller, 'Unable to pay seller');
  }

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract MinimumViableERC20 is ERC20, Pausable, Ownable {
  constructor(
    string memory name,
    string memory symbol,
    address initialAccount,
    uint256 initialBalance
  ) payable ERC20(name, symbol) {
    _mint(initialAccount, initialBalance);
  }

  function mint(address account, uint256 amount) public onlyOwner {
    _mint(account, amount);
  }

  function burn(address account, uint256 amount) public onlyOwner {
    _burn(account, amount);
  }

  function transferInternal(
    address from,
    address to,
    uint256 value
  ) public {
    _transfer(from, to, value);
  }

  function approveInternal(
    address owner,
    address spender,
    uint256 value
  ) public {
    _approve(owner, spender, value);
  }

    /**
  *
  * Useful for scenarios such as preventing trades until the end of an evaluation
  * period, or having an emergency switch for freezing all token transfers in the
  * event of a large bug.
  */
  function _beforeTokenTransfer(
      address from,
      address to,
      uint256 amount
  ) internal virtual override {
      super._beforeTokenTransfer(from, to, amount);

      require(!paused(), "ERC20Pausable: token transfer while paused");
  }
}
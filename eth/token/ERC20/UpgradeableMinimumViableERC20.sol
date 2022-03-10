// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';

contract UpgradeableMinimumViableERC20 is ERC20Upgradeable, PausableUpgradeable, OwnableUpgradeable {
  function initialize() initializer public {
    __Ownable_init();
    __ERC20_init('name', 'symbol');
    __Pausable_init();
  }

  function mint(address account, uint256 amount) public onlyOnwer {
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
}
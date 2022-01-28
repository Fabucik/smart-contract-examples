//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ierc20.sol"; //CHANGE THIS TO IMPORT IERC20 INTERFACE
import "./safemath.sol"; //CHANGE THIS TO IMPORT SAFEMATH LIBARARY

contract Fabutok is IERC20 {

    //using safemath
    using SafeMath for uint256;

    // initiating our token
    string public constant name = "Token"; //CHANGE THIS
    string public constant symbol = "TKN"; //CHANGE THIS
    uint8 public constant decimals = 18;

    //mapping for token balance of address
    mapping (address =>  uint256) balances;

    //mapping for allowing addresses to withdraw
    mapping (address => mapping (address => uint256)) allowed;

    uint256 _totalSupply;

    constructor(uint256 total) {
        _totalSupply = total;

        // giving all tokens to owner of this smart contract
        balances[msg.sender] = _totalSupply;
    }

    //returns total supply of token
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    //returns balance of address
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    //transfers amount of tokens from your address to different
    function transfer(address receiver, uint256 amount) public override returns(bool) {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[receiver] = balances[receiver].add(amount);
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    //approving address to withdraw token from our address
    function approve(address delegate, uint256 amount) public override returns(bool) {
        require(amount <= balances[msg.sender]);
        allowed[msg.sender][delegate] = amount;
        emit Approval(msg.sender, delegate, amount);
        return true;
    }

    //returns how many allowed token does address have
    function allowance(address owner, address delegate) public override view returns(uint256) {
        return allowed[owner][delegate];
    }

    //transfers from address to to approved address (allowed() function is used here)
    function transferFrom(address _from, address _to, uint256 amount) public override returns(bool) {
        require(amount <= balances[_from]);
        require(amount <= allowed[_from][msg.sender]);
        balances[_from] = balances[_from].sub(amount);
        balances[_to] = balances[_to].add(amount);
        emit Transfer(_from, _to, amount);
        return true;
    }
}
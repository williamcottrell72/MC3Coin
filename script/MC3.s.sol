// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MC3Coin, MC3Treasury} from "../src/MC3Coin_flatten.sol";


/* 
# To deply: 

forge script script/MC3.s.sol:MC3TreasuryScript --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY --broadcast
 
 */


contract MC3CoinScript is Script {
    MC3Coin public mc3coin;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        mc3coin = new MC3Coin();
        vm.stopBroadcast();
    }
}

contract MC3TreasuryScript is Script {
    MC3Treasury public mc3tres;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        mc3tres = new MC3Treasury(0x24DbBA52fc9815E55e13d1D688f6861c03f45dAc);
        vm.stopBroadcast();
    }
}

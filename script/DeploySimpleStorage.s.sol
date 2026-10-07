// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();
        // VM -> It is a keyword which can be used in foundry, kind of cheatcode. VM only works in foundry.
        // Any operation that is done after vm.startBroadcast() and before vm.stopBroadcast() will be broadcasted to the network.

        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();
        return simpleStorage;
    }
}

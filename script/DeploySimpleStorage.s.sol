// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// ^0.8.0 means: any Solidity 0.8.x version is OK for this script file.

import {Script} from "forge-std/Script.sol";
// Script comes from Foundry's forge-std library (in lib/forge-std).
// It gives us helpful tools for deploy scripts, especially "vm" cheatcodes.

import {SimpleStorage} from "../src/SimpleStorage.sol";
// Import the contract we want to deploy from our src folder.

/**
 * DeploySimpleStorage
 * -------------------
 * This is NOT the app itself. This is a Foundry *script* that deploys SimpleStorage.
 *
 * How you usually run it (against local Anvil):
 *   forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key <KEY>
 *
 * - Without --broadcast: Foundry only simulates (dry-run). Safer to try first.
 * - With --broadcast: Foundry really sends the transaction to the network.
 */
contract DeploySimpleStorage is Script {
    // "run" is the entry point Foundry calls when you use `forge script`.
    // It returns the deployed contract so you can see the address in the output.
    function run() external returns (SimpleStorage) {
        // vm = Foundry's special object (cheatcodes). It only works inside Foundry.
        // startBroadcast() means: "from here on, treat the next calls as real txs
        // (when --broadcast is used), signed with the private key you passed in."
        vm.startBroadcast();

        // "new SimpleStorage()" creates / deploys a fresh contract on the chain.
        // After this line, simpleStorage holds the new contract address.
        SimpleStorage simpleStorage = new SimpleStorage();

        // stopBroadcast() means: "stop recording / sending deploy transactions."
        vm.stopBroadcast();

        // Hand the deployed contract back to Foundry (shown in the script result).
        return simpleStorage;
    }
}

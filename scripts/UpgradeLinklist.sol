// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@std/Test.sol";
import "@std/Script.sol";
import "../Linklist.sol";
import "../upgradeability/TransparentUpgradeableProxy.sol";

contract UpgradeLinklist is Script {
    address payable linklistProxy = payable(0xFc8C75bD5c26F50798758f387B698f207a016b6A);

    function run() external {
        vm.startBroadcast();

        Linklist linklist = new Linklist();
        TransparentUpgradeableProxy proxy = TransparentUpgradeableProxy(linklistProxy);
        proxy.upgradeTo(address(linklist));

        vm.stopBroadcast();
    }
}
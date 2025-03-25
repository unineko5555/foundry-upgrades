// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { DevOpsTools } from "lib/foundry-devops/src/DevOpsTools.sol";
import { BoxV1 } from "../src/BoxV1.sol";
import { BoxV2 } from "../src/BoxV2.sol";

contract UpgradeBox is Script {

    function run() external returns (address) {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        vm.stopBroadcast();
        address proxy = upgradeBox(mostRecentDeployment, address(newBox));
        return proxy;
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast();
        // payable追加
        BoxV1 proxy = BoxV1(payable(proxyAddress));
        vm.stopBroadcast();
        //new bytes(0) は「アップグレード時に追加で呼び出す関数なし」の意味
        //ProxyがBox2の関数を呼び出せるようになる、ERC1967ProxyのアドレスのままBoxV2が実行される
        proxy.upgradeToAndCall(address(newBox), new bytes(0)); 
        return address(proxy);
    }

}

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {

    function run() external returns(address) {
        address proxy = deployBox();
        return proxy;
    }

    function deployBox() public returns(address) {
        // vm.startBroadcast();
        BoxV1 box = new BoxV1(); // Implementation(Logic), delegatecall to borrow those functions
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), ""); //deploy後に実行されるinitializerの呼び出しにし使用できるが、initialize()がないためdataは空
        //initialize() 関数が BoxV1 の状態を初期化し、その結果として setNumber の呼び出しがリバートしなくなる、testProxyStartAsBoxV1のためにコメントアウト
        BoxV1(address(proxy)).initialize(); 
        // vm.stopBroadcast(); 
        return address(proxy);
    }
}
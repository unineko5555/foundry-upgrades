// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");
    address public proxy;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        vm.prank(OWNER);
        proxy = deployer.run(); //boxでなくproxyでデプロイされる, 今はboxV1を指している
        console.log("setUp - Owner address:", OWNER);
        console.log("setUp - Proxy address:", proxy);
        console.log("setUp - Proxy owner:", BoxV1(proxy).owner()); // BoxV1 に owner() 関数が必要
    }

    function testUpgrades() public {
        BoxV2 box2 = new BoxV2();
        // upgrader.upgradeBox(proxy, address(box2));

        // オーナーアカウントで upgradeToAndCall を直接呼び出す
        console.log("testUpgrades - Owner address:", OWNER);
        vm.prank(OWNER);
        console.log("testUpgrades - msg.sender:", OWNER);

        try BoxV1(payable(proxy)).upgradeToAndCall(address(box2), new bytes(0)) {
            console.log("testUpgrades - upgradeToAndCall success");
        } catch (bytes memory err) {
            if (err.length > 0) {
                console.log("testUpgrades - upgradeToAndCall error:", string(err));
            }
            revert();
        }

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());
        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }

    function testProxyStartAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }

}
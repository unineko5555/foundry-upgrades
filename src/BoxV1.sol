// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    // @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    uint256 internal number;

    // testProxyStartAsBoxV1を通すためにコメントアウト
    // function setNumber(uint256 _number) external {
    //     number = _number;
    // }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }
    // onlyOwner追加
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // owner() 関数を追加
    function owner() public view override returns (address) {
        return OwnableUpgradeable.owner();
    }
}
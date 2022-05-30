// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

contract Web3EntryExtendStorage {
    address internal periphery; // slot 21
    mapping(uint256 => address) internal _operatorByProfile;
    address public resolver;
}

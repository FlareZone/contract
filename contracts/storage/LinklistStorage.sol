// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "../libraries/DataTypes.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract LinklistStorage {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using EnumerableSet for EnumerableSet.AddressSet;

    address internal web3Entry;

    // tokenId => linkType
    mapping(uint256 => bytes32) internal linkTypes;

    // tokenId =>  profileIds
    mapping(uint256 => EnumerableSet.UintSet) internal linkingProfileList;
    // tokenId => external addresses
    mapping(uint256 => EnumerableSet.AddressSet) internal linkingAddressList;

    // tokenId => linkKeys
    mapping(uint256 => EnumerableSet.Bytes32Set) internal linkKeysList;
    // linkKey => linking ERC721
    mapping(bytes32 => DataTypes.linkERC721Item) internal linkingERC721list;
    // linkKey => linking Note
    mapping(bytes32 => DataTypes.linkNoteItem) internal linkNoteList;

    // tokenId => profileId
    mapping(uint256 => uint256) internal currentTakeOver;
    mapping(uint256 => string) internal _uris; // tokenId => tokenURI
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../contracts/Web3Entry.sol";
import "../contracts/Web3EntryV1.sol";
import "../contracts/libraries/DataTypes.sol";
import "../contracts/Web3Entry.sol";
import "../contracts/upgradeability/TransparentUpgradeableProxy.sol";
import "./helpers/Const.sol";
import "./helpers/utils.sol";
import "./helpers/SetUp.sol";
import "../../contracts/Web3Entry.sol";
import "../contracts/Linklist.sol";
import "../contracts/misc/Periphery.sol";
import "../contracts/misc/CharacterBoundToken.sol";
import "../contracts/libraries/DataTypes.sol";
import "../contracts/MintNFT.sol";
import "../contracts/upgradeability/TransparentUpgradeableProxy.sol";
import "../contracts/modules/link/ApprovalLinkModule4Character.sol";
import "../contracts/mocks/NFT.sol";
import "../contracts/Resolver.sol";

contract UpgradeOperatorTest is Test, Utils {
    Web3EntryV1 web3EntryV1Impl;
    Web3EntryV1 web3EntryV1;
    Web3Entry web3EntryImpl;
    Web3Entry web3Entry;
    TransparentUpgradeableProxy proxyWeb3Entry;
    address public admin = address(0x999999999999999999999999999999);
    address public alice = address(0x1111);
    address public bob = address(0x2222);
    address public carol = address(0x3333);

    function setUp() public {
        web3EntryV1Impl = new Web3EntryV1();
        proxyWeb3Entry = new TransparentUpgradeableProxy(address(web3EntryV1Impl), admin, "");
    }

    function testImpl() public {
        vm.startPrank(admin);
        address implV1 = proxyWeb3Entry.implementation();
        assertEq(implV1, address(web3EntryV1Impl));

        // upgrade
        web3EntryImpl = new Web3Entry();
        proxyWeb3Entry.upgradeTo(address(web3EntryImpl));
        address impl = proxyWeb3Entry.implementation();
        assertEq(impl, address(web3EntryImpl));
        vm.stopPrank();
    }

    function testCheckStorage() public {
        // use web3entryV1 to generate some data
        Web3EntryV1(address(proxyWeb3Entry)).createCharacter(
            makeCharacterData(Const.MOCK_CHARACTER_HANDLE, alice)
        );
        Web3EntryV1(address(proxyWeb3Entry)).createCharacter(
            makeCharacterData(Const.MOCK_CHARACTER_HANDLE2, bob)
        );

        // set operator using Web3entryV1
        vm.prank(alice);
        Web3EntryV1(address(proxyWeb3Entry)).setOperator(Const.FIRST_CHARACTER_ID, bob);

        // upgrade web3Entry
        web3EntryImpl = new Web3Entry();
        vm.prank(admin);
        proxyWeb3Entry.upgradeTo(address(web3EntryImpl));

        // set operator using new web3entry
        vm.prank(alice);
        Web3Entry(address(proxyWeb3Entry)).addOperator(Const.FIRST_CHARACTER_ID, carol);
        // now bob and bob and carol should be operator
        vm.prank(bob);
        Web3Entry(address(proxyWeb3Entry)).setCharacterUri(
            Const.FIRST_CHARACTER_ID,
            "https://example.com/profile"
        );
        vm.prank(carol);
        Web3Entry(address(proxyWeb3Entry)).setCharacterUri(
            Const.FIRST_CHARACTER_ID,
            "https://example.com/profile"
        );

        // delete operator using new web3Entry
        vm.prank(alice);
        // disapprove carol
        Web3Entry(address(proxyWeb3Entry)).removeOperator(Const.FIRST_CHARACTER_ID, carol);
        // carol is not operator now
        vm.prank(carol);
        vm.expectRevert(abi.encodePacked("NotCharacterOwnerNorOperator"));
        Web3Entry(address(proxyWeb3Entry)).setCharacterUri(
            Const.FIRST_CHARACTER_ID,
            "https://example.com/profile"
        );

        // delete operator set up by web3EntryV1
        vm.prank(alice);
        Web3Entry(address(proxyWeb3Entry)).removeOperator(Const.FIRST_CHARACTER_ID, bob);
        vm.prank(bob);
        vm.expectRevert(abi.encodePacked("NotCharacterOwnerNorOperator"));
        Web3Entry(address(proxyWeb3Entry)).setCharacterUri(
            Const.FIRST_CHARACTER_ID,
            "https://example.com/profile"
        );
    }
}

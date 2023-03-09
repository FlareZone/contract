// SPDX-License-Identifier: MIT
// solhint-disable comprehensive-interface
pragma solidity 0.8.16;

import {Test} from "forge-std/Test.sol";
import {ErrCallerNotWeb3Entry} from "../contracts/libraries/Error.sol";
import {MintNFT} from "../contracts/MintNFT.sol";
import {Utils} from "./helpers/Utils.sol";
import {SetUp} from "./helpers/SetUp.sol";

contract MintNFTTest is Test, Utils {
    address public alice = address(0x1111);
    address public bob = address(0x2222);
    address public carol = address(0x3333);

    MintNFT public nft;
    address public web3Entry = address(1);

    function setUp() public {
        nft = new MintNFT();
        nft.initialize(1, 1, web3Entry, "name", "symbol");
    }

    function testMint() public {
        // mint nft
        vm.prank(web3Entry);
        nft.mint(bob);

        // check states
        assertEq(nft.totalSupply(), 1);
        assertEq(nft.balanceOf(bob), 1);
        assertEq(nft.ownerOf(1), bob);
    }

    function testMintFail() public {
        // caller is not web3Entry
        vm.expectRevert(abi.encodeWithSelector(ErrCallerNotWeb3Entry.selector));
        nft.mint(bob);
    }
}

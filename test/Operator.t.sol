// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../contracts/Web3Entry.sol";
import "../contracts/libraries/DataTypes.sol";
import "../contracts/Web3Entry.sol";
import "../contracts/upgradeability/TransparentUpgradeableProxy.sol";
import "../contracts/modules/link/ApprovalLinkModule4Character.sol";
import "../contracts/modules/link/ApprovalLinkModule4Note.sol";
import "./helpers/Const.sol";
import "./helpers/utils.sol";
import "./helpers/SetUp.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../contracts/libraries/OP.sol";
import "./helpers/DEFAULT_OP.sol";

contract OperatorTest is Test, SetUp, Utils {
    address public alice = address(0x1111);
    address public bob = address(0x2222);
    address public carol = address(0x3333);
    address public dick = address(0x4444);
    address public erik = address(0x5555);

    function setUp() public {
        _setUp();

        // create character
        web3Entry.createCharacter(makeCharacterData(Const.MOCK_CHARACTER_HANDLE, alice));
        web3Entry.createCharacter(makeCharacterData(Const.MOCK_CHARACTER_HANDLE2, bob));
    }

    function testGrantOperatorPermissions() public {
        expectEmit(CheckTopic1 | CheckTopic2 | CheckTopic3 | CheckData);
        emit Events.GrantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );

        // alice set bob as her operator with DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );
    }

    function testGrantOpertorPermissionsFail() public {
        // only only owner can grant operator
        vm.prank(bob);
        vm.expectRevert(abi.encodePacked("NotCharacterOwner"));
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );
    }

    function testGrantNoteOpertorPermission() public {
        expectEmit(CheckTopic1 | CheckTopic2 | CheckTopic3 | CheckData);
        emit Events.GrantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );

        vm.startPrank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );

        expectEmit(CheckTopic1 | CheckTopic2 | CheckTopic3 | CheckData);
        emit Events.GrantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            bob,
            DEFAULT_OP.DEFAULT_NOTE_PERMISSION_BITMAP
        );
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));
        web3Entry.grantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            bob,
            DEFAULT_OP.DEFAULT_NOTE_PERMISSION_BITMAP
        );
    }

    function testGrantNoteOpertorPermissionFail() public {
        // only only owner can grant note operator
        vm.prank(bob);
        vm.expectRevert(abi.encodePacked("NotCharacterOwner"));
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );
    }

    function testgetOperatorPermissions() public {
        // alice grant bob DEFAULT_OP.DEFAULT_PERMISSION_BITMAP permission
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );
        assertEq(
            web3Entry.getOperatorPermissions(Const.FIRST_CHARACTER_ID, bob),
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );

        // alice grant bob DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP permission
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP
        );
        assertEq(
            web3Entry.getOperatorPermissions(Const.FIRST_CHARACTER_ID, bob),
            DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP
        );

        // alice grant bob DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP permission
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP
        );
        assertEq(
            web3Entry.getOperatorPermissions(Const.FIRST_CHARACTER_ID, bob),
            DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP
        );
    }

    function testgetOperatorPermissions4Note() public {
        // alice grant bob DEFAULT_OP.DEFAULT_PERMISSION_BITMAP permission
        vm.startPrank(alice);
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));
        web3Entry.grantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            bob,
            DEFAULT_OP.DEFAULT_NOTE_PERMISSION_BITMAP
        );
        assertEq(
            web3Entry.getOperatorPermissions4Note(
                Const.FIRST_CHARACTER_ID,
                Const.FIRST_NOTE_ID,
                bob
            ),
            DEFAULT_OP.DEFAULT_NOTE_PERMISSION_BITMAP
        );
    }

    function testOperatorSyncCan() public {
        // alice grant bob as DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP permission
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP
        );

        vm.startPrank(bob);
        // operatorSync can post note(id = 236)
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));
    }

    function testOperatorSignCan() public {
        // alice grant bob as DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP permission
        vm.startPrank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP
        );

        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            carol,
            DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP
        );

        vm.stopPrank();

        vm.startPrank(bob);
        // operatorSign can postNote
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));

        // operatorSign can setCharacterUri
        web3Entry.setCharacterUri(Const.FIRST_CHARACTER_ID, "https://example.com/profile");

        // operatorSign can linkCharacter
        web3Entry.linkCharacter(
            DataTypes.linkCharacterData(
                Const.FIRST_CHARACTER_ID,
                Const.SECOND_CHARACTER_ID,
                Const.LikeLinkType,
                new bytes(0)
            )
        );
        web3Entry.unlinkCharacter(
            DataTypes.unlinkCharacterData(
                Const.FIRST_CHARACTER_ID,
                Const.SECOND_CHARACTER_ID,
                Const.LikeLinkType
            )
        );

        web3Entry.createThenLinkCharacter(
            DataTypes.createThenLinkCharacterData(
                Const.FIRST_CHARACTER_ID,
                Const.MOCK_TO_ADDRESS,
                Const.LinkItemTypeCharacter
            )
        );

        // operatorSign can setlinklisturi
        web3Entry.setLinklistUri(1, Const.MOCK_URI);

        web3Entry.linkNote(
            DataTypes.linkNoteData(
                Const.FIRST_CHARACTER_ID,
                Const.FIRST_CHARACTER_ID,
                Const.FIRST_NOTE_ID,
                Const.FollowLinkType,
                new bytes(0)
            )
        );
        // unlinkNote
        web3Entry.unlinkNote(
            DataTypes.unlinkNoteData(
                Const.FIRST_CHARACTER_ID,
                Const.FIRST_CHARACTER_ID,
                Const.FIRST_NOTE_ID,
                Const.FollowLinkType
            )
        );
        // linkERC721
        nft.mint(bob);
        web3Entry.linkERC721(
            DataTypes.linkERC721Data(
                Const.FIRST_CHARACTER_ID,
                address(nft),
                1,
                Const.LikeLinkType,
                new bytes(0)
            )
        );

        // unlinkERC721
        web3Entry.unlinkERC721(
            DataTypes.unlinkERC721Data(
                Const.FIRST_CHARACTER_ID,
                address(nft),
                1,
                Const.LikeLinkType
            )
        );
        // linkAddress
        web3Entry.linkAddress(
            DataTypes.linkAddressData(
                Const.FIRST_CHARACTER_ID,
                address(0x1232414),
                Const.LikeLinkType,
                new bytes(0)
            )
        );

        // unlinkAddress
        web3Entry.unlinkAddress(
            DataTypes.unlinkAddressData(
                Const.FIRST_CHARACTER_ID,
                address(0x1232414),
                Const.LikeLinkType
            )
        );
        // linkAnyUri
        web3Entry.linkAnyUri(
            DataTypes.linkAnyUriData(
                Const.FIRST_CHARACTER_ID,
                "ipfs://anyURI",
                Const.LikeLinkType,
                new bytes(0)
            )
        );

        // unlinkAnyUri
        web3Entry.unlinkAnyUri(
            DataTypes.unlinkAnyUriData(
                Const.FIRST_CHARACTER_ID,
                "ipfs://anyURI",
                Const.LikeLinkType
            )
        );

        // linkLinklist
        web3Entry.linkLinklist(
            DataTypes.linkLinklistData(
                Const.FIRST_CHARACTER_ID,
                1,
                Const.LikeLinkType,
                new bytes(0)
            )
        );

        // unlinkLinklist
        web3Entry.unlinkLinklist(
            DataTypes.unlinkLinklistData(Const.FIRST_CHARACTER_ID, 1, Const.LikeLinkType)
        );

        ApprovalLinkModule4Character linkModule4Character = new ApprovalLinkModule4Character(
            address(web3Entry)
        );

        // setLinkModule4Character
        web3Entry.setLinkModule4Character(
            DataTypes.setLinkModule4CharacterData(
                Const.FIRST_CHARACTER_ID,
                address(linkModule4Character),
                new bytes(0)
            )
        );

        // setLinkModule4Linklist
        // i use the address(linkModule4Character) for link module(cuz the logic here is the same)
        web3Entry.setLinkModule4Linklist(
            DataTypes.setLinkModule4LinklistData(
                Const.FIRST_LINKLIST_ID,
                address(linkModule4Character),
                new bytes(0)
            )
        );

        // postNote4Character
        web3Entry.postNote4Character(
            makePostNoteData(Const.FIRST_CHARACTER_ID),
            Const.FIRST_CHARACTER_ID
        );

        // postNote4Address
        web3Entry.postNote4Address(makePostNoteData(Const.FIRST_CHARACTER_ID), address(0x328));

        // postNote4Linklist
        web3Entry.postNote4Linklist(
            makePostNoteData(Const.FIRST_CHARACTER_ID),
            Const.FIRST_LINKLIST_ID
        );

        // postNote4Note
        web3Entry.postNote4Note(
            makePostNoteData(Const.FIRST_CHARACTER_ID),
            DataTypes.NoteStruct(Const.FIRST_CHARACTER_ID, Const.FIRST_NOTE_ID)
        );

        // postNote4ERC721
        nft.mint(bob);
        web3Entry.postNote4ERC721(
            makePostNoteData(Const.FIRST_CHARACTER_ID),
            DataTypes.ERC721Struct(address(nft), 1)
        );

        // postNote4AnyUri
        web3Entry.postNote4AnyUri(makePostNoteData(Const.FIRST_CHARACTER_ID), "ipfs://anyURI");

        vm.stopPrank();

        // operator with owner permissions can:
        // alice grant bob all permissions including owner permissions
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(Const.FIRST_CHARACTER_ID, bob, ~uint256(0));
        vm.startPrank(bob);
        web3Entry.setHandle(Const.FIRST_CHARACTER_ID, "mynewhandle");
        web3Entry.setSocialToken(Const.FIRST_CHARACTER_ID, address(0x1234567));
    }

    function testOperatorFail() public {
        // alice set bob as her operator with DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );

        // default operator can't setHandle
        vm.startPrank(bob);
        vm.expectRevert(abi.encodePacked("NotEnoughPermission"));
        web3Entry.setHandle(Const.FIRST_CHARACTER_ID, "new-handle");

        // set primary character id
        // user can only set primary character id to himself
        vm.expectRevert(abi.encodePacked("NotCharacterOwner"));
        web3Entry.setPrimaryCharacterId(Const.FIRST_CHARACTER_ID);

        // set social token
        vm.expectRevert(abi.encodePacked("NotEnoughPermission"));
        web3Entry.setSocialToken(Const.FIRST_CHARACTER_ID, address(0x132414));

        // grant operator
        vm.expectRevert(abi.encodePacked("NotCharacterOwner"));
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            carol,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );

        // grant operator for note
        vm.expectRevert(abi.encodePacked("NotCharacterOwner"));
        web3Entry.grantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            carol,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );

        vm.expectRevert(abi.encodePacked("NotCharacterOwner"));
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.DEFAULT_PERMISSION_BITMAP
        );
        vm.stopPrank();

        // fail after canceling grant
        vm.startPrank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP
        );
        web3Entry.grantOperatorPermissions(Const.FIRST_CHARACTER_ID, bob, 0);
        vm.stopPrank();
        vm.prank(bob);
        vm.expectRevert(abi.encodePacked("NotEnoughPermission"));
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));

        // operator with sync permission can't sign
        vm.prank(alice);
        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSYNC_PERMISSION_BITMAP
        );
        vm.prank(bob);
        vm.expectRevert(abi.encodePacked("NotEnoughPermission"));
        web3Entry.setNoteUri(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            Const.MOCK_NEW_NOTE_URI
        );
    }

    function testOperator4NoteCan() public {
        // alice grant bob as DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP permission
        vm.startPrank(alice);
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));
        ApprovalLinkModule4Note linkModule4Note = new ApprovalLinkModule4Note(address(web3Entry));

        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP
        );
        web3Entry.grantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            bob,
            DEFAULT_OP.DEFAULT_NOTE_PERMISSION_BITMAP
        );
        vm.stopPrank();

        // setLinkModule4Note
        vm.startPrank(bob);
        /*
      web3Entry.setLinkModule4Note(
          DataTypes.setLinkModule4NoteData(
              Const.FIRST_CHARACTER_ID,
              Const.FIRST_NOTE_ID,
              address(linkModule4Note),
              new bytes(0)
          )
      );
      */

        // setMintModule4Note
        ApprovalMintModule mintModule = new ApprovalMintModule(address(web3Entry));
        web3Entry.setMintModule4Note(
            DataTypes.setMintModule4NoteData(
                Const.FIRST_CHARACTER_ID,
                Const.FIRST_NOTE_ID,
                address(mintModule),
                new bytes(0)
            )
        );

        // setNoteUri
        web3Entry.setNoteUri(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            Const.MOCK_NEW_NOTE_URI
        );

        // lockNote
        web3Entry.lockNote(Const.FIRST_CHARACTER_ID, Const.FIRST_NOTE_ID);

        // delete note
        web3Entry.deleteNote(Const.FIRST_CHARACTER_ID, Const.FIRST_NOTE_ID);
    }

    function testOperator4NoteFail() public {
        // alice grant bob as DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP permission
        vm.startPrank(alice);
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));
        web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));

        web3Entry.grantOperatorPermissions(
            Const.FIRST_CHARACTER_ID,
            bob,
            DEFAULT_OP.OPERATORSIGN_PERMISSION_BITMAP
        );
        web3Entry.grantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            bob,
            DEFAULT_OP.DEFAULT_NOTE_PERMISSION_BITMAP
        );

        web3Entry.grantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            carol,
            DEFAULT_OP.DEFAULT_NOTE_PERMISSION_BITMAP
        );
        vm.stopPrank();

        // granted operator can't operator without note permission
        vm.prank(carol);
        vm.expectRevert(abi.encodePacked("NotEnoughPermission"));
        // setNoteUri
        web3Entry.setNoteUri(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            Const.MOCK_NEW_NOTE_URI
        );

        // can't deleteNote if the permission is set as false
        vm.prank(alice);
        web3Entry.grantOperatorPermissions4Note(
            Const.FIRST_CHARACTER_ID,
            Const.FIRST_NOTE_ID,
            bob,
            ~(~uint256(0) << 4)
        );

        vm.expectRevert(abi.encodePacked("NotEnoughPermissionForThisNote"));
        vm.prank(bob);
        web3Entry.deleteNote(Const.FIRST_CHARACTER_ID, Const.FIRST_NOTE_ID);
    }

    function testMigrate() public {
        // TODO how to test migrate?
        // vm.startPrank(alice);
        // web3Entry.setOperator(Const.FIRST_CHARACTER_ID, bob);
        // web3Entry.addOperator(Const.FIRST_CHARACTER_ID, carol);
        // web3Entry.addOperator(Const.FIRST_CHARACTER_ID, dick);
        // web3Entry.postNote(makePostNoteData(Const.FIRST_CHARACTER_ID));
        // vm.stopPrank();
        // uint256[] memory characters = new uint256[](1);
        // characters[0] = 1;
        // web3Entry.migrateOperator(characters);
        // vm.startPrank(bob);
        // web3Entry.setCharacterUri(Const.FIRST_CHARACTER_ID, "https://example.com/profile");
    }
}

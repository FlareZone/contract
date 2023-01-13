// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./Web3EntryBase.sol";
import "./libraries/OP.sol";
import "./libraries/OperatorLogic.sol";

contract Web3Entry is Web3EntryBase {
    using EnumerableSet for EnumerableSet.AddressSet;

    // characterId => operator => permissionsBitMap
    mapping(uint256 => mapping(address => uint256)) internal _operatorsPermissionBitMap; // slot 25

    // characterId => noteId => Operators4Note
    // only for set note uri
    mapping(uint256 => mapping(uint256 => DataTypes.Operators4Note)) internal _operators4Note; // slot 26

    /**
     * @notice Grant an address as an operator and authorize it with custom permissions.
     * @param characterId ID of your character that you want to authorize.
     * @param operator Address to grant operator permissions to.
     * @param permissionBitMap Bitmap used for finer grained operator permissions controls.
     * @dev Every bit in permissionBitMap stands for a corresponding method in Web3Entry. more details in OP.sol.
     */
    function grantOperatorPermissions(
        uint256 characterId,
        address operator,
        uint256 permissionBitMap
    ) external override {
        _validateCallerPermission(characterId, OP.GRANT_OPERATOR_PERMISSIONS);
        OperatorLogic.grantOperatorPermissions(
            characterId,
            operator,
            permissionBitMap,
            _operatorsByCharacter,
            _operatorsPermissionBitMap
        );
    }

    /**
     * @notice Grant operators allowlist and blocklist roles of a note.
     * @param characterId ID of character that you want to set.
     * @param noteId ID of note that you want to set.
     * @param blocklist blocklist addresses that you want to grant.
     * @param allowlist allowlist addresses that you want to grant.
     */
    function grantOperators4Note(
        uint256 characterId,
        uint256 noteId,
        address[] calldata blocklist,
        address[] calldata allowlist
    ) external override {
        _validateCallerPermission(characterId, OP.GRANT_OPERATORS_FOR_NOTE);
        _validateNoteExists(characterId, noteId);
        OperatorLogic.grantOperators4Note(
            characterId,
            noteId,
            blocklist,
            allowlist,
            _operators4Note
        );
    }

    /**
     * @notice Get permission bitmap of an operator.
     * @param characterId ID of character that you want to check.
     * @param operator Address to grant operator permissions to.
     * @return Permission bitmap of this operator.
     */
    function getOperatorPermissions(uint256 characterId, address operator)
        external
        view
        override
        returns (uint256)
    {
        return _operatorsPermissionBitMap[characterId][operator];
    }

    /**
     * @notice Get operators blocklist and allowlist for a note.
     * @param characterId ID of character to query.
     * @param noteId ID of note to query.
     */
    function getOperators4Note(uint256 characterId, uint256 noteId)
        external
        view
        override
        returns (address[] memory blocklist, address[] memory allowlist)
    {
        blocklist = _operators4Note[characterId][noteId]
            .blocklists[_operators4Note[characterId][noteId].blocklistId]
            .values();
        allowlist = _operators4Note[characterId][noteId]
            .allowlists[_operators4Note[characterId][noteId].allowlistId]
            .values();
        return (blocklist, allowlist);
    }

    /**
     * @notice Query if a operator has permission for a note.
     * @param characterId ID of character that you want to query.
     * @param noteId ID of note that you want to query.
     * @param operator Address to query.
     * @return true if Operator has permission for a note, otherwise false.
     */
    function isOperatorAllowedForNote(
        uint256 characterId,
        uint256 noteId,
        address operator
    ) external view override returns (bool) {
        return _isOperatorAllowedForNote(characterId, noteId, operator);
    }

    function _isOperatorAllowedForNote(
        uint256 characterId,
        uint256 noteId,
        address operator
    ) internal view returns (bool) {
        DataTypes.Operators4Note storage op = _operators4Note[characterId][noteId];

        // check blocklist
        uint256 currentIndex = op.blocklistId; // the current index of blocklistSet
        if (op.blocklists[currentIndex].contains(operator)) {
            return false;
        }
        // check allowlist
        currentIndex = op.allowlistId; // the current index of allowlistSet
        if (op.allowlists[currentIndex].contains(operator)) {
            return true;
        }
        // check character operator permission
        return _checkBit(_operatorsPermissionBitMap[characterId][operator], OP.SET_NOTE_URI);
    }

    function _validateCallerPermission(uint256 characterId, uint256 permissionId)
        internal
        view
        override
    {
        // check character owner
        if (_callerIsCharacterOwner(characterId)) {
            return;
        }

        //  check operator permission for msg.sender
        uint256 bitMap = _operatorsPermissionBitMap[characterId][msg.sender];
        if (_checkBit(bitMap, permissionId)) {
            return;
        }

        // check operator permission for tx.origin
        if (msg.sender == periphery) {
            bitMap = _operatorsPermissionBitMap[characterId][tx.origin];
            if (_checkBit(bitMap, permissionId)) {
                return;
            }
        }

        revert("NotEnoughPermission");
    }

    function _callerIsCharacterOwner(uint256 characterId) internal view returns (bool) {
        address owner = ownerOf(characterId);

        if (msg.sender == owner) {
            // caller is character owner
            return true;
        }
        if (msg.sender == periphery && tx.origin == owner) {
            // caller is periphery, and tx.origin is character owner
            return true;
        }

        return false;
    }

    function _validateCallerPermission4Note(uint256 characterId, uint256 noteId)
        internal
        view
        override
    {
        // check character owner
        if (_callerIsCharacterOwner(characterId)) {
            return;
        }

        // check note permission for caller
        if (_isOperatorAllowedForNote(characterId, noteId, msg.sender)) {
            return;
        }

        // check note permission for tx.origin
        if (msg.sender == periphery) {
            if (_isOperatorAllowedForNote(characterId, noteId, tx.origin)) {
                return;
            }
        }

        revert("NotEnoughPermissionForThisNote");
    }

    /**
     * @dev _checkBit checks if the value of the i'th bit of x is 1
     */
    function _checkBit(uint256 x, uint256 i) internal pure returns (bool) {
        return (x >> i) & 1 == 1;
    }

    /**
     * @dev Operator lists will be reset to blank before the characters are transferred in order to grant the
     * whole control power to receivers of character transfers.
     * Permissions4Note is left unset, because permissions for notes are always stricter than default.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        uint256 len = _operatorsByCharacter[tokenId].length();
        address[] memory operators = _operatorsByCharacter[tokenId].values();
        for (uint256 i = 0; i < len; i++) {
            _operatorsPermissionBitMap[tokenId][operators[i]] = 0;
            _operatorsByCharacter[tokenId].remove(operators[i]);
        }
        if (_primaryCharacterByAddress[from] != 0) {
            _primaryCharacterByAddress[from] = 0;
        }
        super._beforeTokenTransfer(from, to, tokenId);
    }
}

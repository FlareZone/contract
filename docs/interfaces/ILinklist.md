# Solidity API

## ILinklist

### mint

```solidity
function mint(uint256 characterId, bytes32 linkType, uint256 tokenId) external
```

### setUri

```solidity
function setUri(uint256 tokenId, string uri) external
```

### addLinkingCharacterId

```solidity
function addLinkingCharacterId(uint256 tokenId, uint256 toCharacterId) external
```

### removeLinkingCharacterId

```solidity
function removeLinkingCharacterId(uint256 tokenId, uint256 toCharacterId) external
```

### getLinkingCharacterIds

```solidity
function getLinkingCharacterIds(uint256 tokenId) external view returns (uint256[])
```

### getLinkingCharacterListLength

```solidity
function getLinkingCharacterListLength(uint256 tokenId) external view returns (uint256)
```

### addLinkingNote

```solidity
function addLinkingNote(uint256 tokenId, uint256 toCharacterId, uint256 toNoteId) external returns (bytes32)
```

### removeLinkingNote

```solidity
function removeLinkingNote(uint256 tokenId, uint256 toCharacterId, uint256 toNoteId) external
```

### getLinkingNotes

```solidity
function getLinkingNotes(uint256 tokenId) external view returns (struct DataTypes.NoteStruct[] results)
```

### getLinkingNote

```solidity
function getLinkingNote(bytes32 linkKey) external view returns (struct DataTypes.NoteStruct)
```

### getLinkingNoteListLength

```solidity
function getLinkingNoteListLength(uint256 tokenId) external view returns (uint256)
```

### addLinkingCharacterLink

```solidity
function addLinkingCharacterLink(uint256 tokenId, struct DataTypes.CharacterLinkStruct linkData) external
```

### removeLinkingCharacterLink

```solidity
function removeLinkingCharacterLink(uint256 tokenId, struct DataTypes.CharacterLinkStruct linkData) external
```

### getLinkingCharacterLinks

```solidity
function getLinkingCharacterLinks(uint256 tokenId) external view returns (struct DataTypes.CharacterLinkStruct[] results)
```

### getLinkingCharacterLink

```solidity
function getLinkingCharacterLink(bytes32 linkKey) external view returns (struct DataTypes.CharacterLinkStruct)
```

### getLinkingCharacterLinkListLength

```solidity
function getLinkingCharacterLinkListLength(uint256 tokenId) external view returns (uint256)
```

### addLinkingERC721

```solidity
function addLinkingERC721(uint256 tokenId, address tokenAddress, uint256 erc721TokenId) external returns (bytes32)
```

### removeLinkingERC721

```solidity
function removeLinkingERC721(uint256 tokenId, address tokenAddress, uint256 erc721TokenId) external
```

### getLinkingERC721s

```solidity
function getLinkingERC721s(uint256 tokenId) external view returns (struct DataTypes.ERC721Struct[] results)
```

### getLinkingERC721

```solidity
function getLinkingERC721(bytes32 linkKey) external view returns (struct DataTypes.ERC721Struct)
```

### getLinkingERC721ListLength

```solidity
function getLinkingERC721ListLength(uint256 tokenId) external view returns (uint256)
```

### addLinkingAddress

```solidity
function addLinkingAddress(uint256 tokenId, address ethAddress) external
```

### removeLinkingAddress

```solidity
function removeLinkingAddress(uint256 tokenId, address ethAddress) external
```

### getLinkingAddresses

```solidity
function getLinkingAddresses(uint256 tokenId) external view returns (address[])
```

### getLinkingAddressListLength

```solidity
function getLinkingAddressListLength(uint256 tokenId) external view returns (uint256)
```

### addLinkingAnyUri

```solidity
function addLinkingAnyUri(uint256 tokenId, string toUri) external returns (bytes32)
```

### removeLinkingAnyUri

```solidity
function removeLinkingAnyUri(uint256 tokenId, string toUri) external
```

### getLinkingAnyUris

```solidity
function getLinkingAnyUris(uint256 tokenId) external view returns (string[] results)
```

### getLinkingAnyUri

```solidity
function getLinkingAnyUri(bytes32 linkKey) external view returns (string)
```

### getLinkingAnyListLength

```solidity
function getLinkingAnyListLength(uint256 tokenId) external view returns (uint256)
```

### addLinkingLinklistId

```solidity
function addLinkingLinklistId(uint256 tokenId, uint256 linklistId) external
```

### removeLinkingLinklistId

```solidity
function removeLinkingLinklistId(uint256 tokenId, uint256 linklistId) external
```

### getLinkingLinklistIds

```solidity
function getLinkingLinklistIds(uint256 tokenId) external view returns (uint256[])
```

### getLinkingLinklistLength

```solidity
function getLinkingLinklistLength(uint256 tokenId) external view returns (uint256)
```

### getCurrentTakeOver

```solidity
function getCurrentTakeOver(uint256 tokenId) external view returns (uint256)
```

### getLinkType

```solidity
function getLinkType(uint256 tokenId) external view returns (bytes32)
```

### Uri

```solidity
function Uri(uint256 tokenId) external view returns (string)
```

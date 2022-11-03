# Solidity API

## CharacterBoundToken

### MINTER_ROLE

```solidity
bytes32 MINTER_ROLE
```

### Mint

```solidity
event Mint(uint256 to, uint256 tokenId, uint256 tokenNumber)
```

### Burn

```solidity
event Burn(uint256 from, uint256 tokenId, uint256 amount)
```

### _balances

```solidity
mapping(uint256 => mapping(uint256 => uint256)) _balances
```

### _operatorApprovals

```solidity
mapping(address => mapping(address => bool)) _operatorApprovals
```

### _tokenURIs

```solidity
mapping(uint256 => string) _tokenURIs
```

### _web3Entry

```solidity
address _web3Entry
```

### currentTokenNumbers

```solidity
mapping(uint256 => uint256) currentTokenNumbers
```

### constructor

```solidity
constructor(address web3Entry) public
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

### mint

```solidity
function mint(uint256 characterId, uint256 tokenId) external
```

### burn

```solidity
function burn(uint256 characterId, uint256 tokenId, uint256 amount) external
```

### setTokenURI

```solidity
function setTokenURI(uint256 tokenId, string tokenURI) external
```

### balanceOf

```solidity
function balanceOf(address account, uint256 tokenId) public view virtual returns (uint256 balance)
```

### balanceOf

```solidity
function balanceOf(uint256 characterId, uint256 tokenId) public view virtual returns (uint256)
```

### balanceOfBatch

```solidity
function balanceOfBatch(address[] accounts, uint256[] tokenIds) external view virtual returns (uint256[])
```

### uri

```solidity
function uri(uint256 tokenId) public view virtual returns (string)
```

### _setURI

```solidity
function _setURI(uint256 tokenId, string tokenURI) internal virtual
```

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool approved) external virtual
```

_See {IERC1155-setApprovalForAll}._

### isApprovedForAll

```solidity
function isApprovedForAll(address account, address operator) public view virtual returns (bool)
```

_See {IERC1155-isApprovedForAll}._

### safeTransferFrom

```solidity
function safeTransferFrom(address, address, uint256, uint256, bytes) external virtual
```

_See {IERC1155-safeTransferFrom}._

### safeBatchTransferFrom

```solidity
function safeBatchTransferFrom(address, address, uint256[], uint256[], bytes) external virtual
```

_See {IERC1155-safeBatchTransferFrom}._

### _setApprovalForAll

```solidity
function _setApprovalForAll(address owner, address operator, bool approved) internal virtual
```

_Approve `operator` to operate on all of `owner` tokens

Emits an {ApprovalForAll} event._

# Solidity API

## Resolver

### ensRecords

```solidity
mapping(bytes32 => address) ensRecords
```

### rnsRecords

```solidity
mapping(bytes32 => address) rnsRecords
```

### totalENSCount

```solidity
uint256 totalENSCount
```

### totalRNSCount

```solidity
uint256 totalRNSCount
```

### addENSRecords

```solidity
function addENSRecords(string[] labels, address[] owners) external
```

### addRNSRecords

```solidity
function addRNSRecords(string[] labels, address[] owners) external
```

### deleteENSRecords

```solidity
function deleteENSRecords(string[] labels) external
```

### deleteRNSRecords

```solidity
function deleteRNSRecords(string[] labels) external
```

### getENSRecord

```solidity
function getENSRecord(string label) external view returns (address)
```

### getRNSRecord

```solidity
function getRNSRecord(string label) external view returns (address)
```

### getTotalENSCount

```solidity
function getTotalENSCount() external view returns (uint256)
```

### getTotalRNSCount

```solidity
function getTotalRNSCount() external view returns (uint256)
```

### _addRecords

```solidity
function _addRecords(string[] labels, address[] owners, bool ens) internal
```

### _deleteRecords

```solidity
function _deleteRecords(string[] labels, bool ens) internal
```

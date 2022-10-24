<p align='center'>
<img src="https://avatars.githubusercontent.com/u/103565959" alt="CrossSync Logo" width="60" height="60" />
</p>

<h1  align='center'>Crossbell</h1>

> Cross-platform, ring a bell.

<p align="center">
    <br />
    <a href="https://github.com/Crossbell-Box/Crossbell-Contracts/wiki"><strong>Explore the Wiki »</strong></a>
    <br />
    <br />
    <a href="https://crossbell.io">View Website</a>
    ·
    <a href="https://discord.gg/ecpfdHHw">Join Discord</a>
    ·
    <a href="https://github.com/Crossbell-Box/Crossbell-Contracts/issues">Report Bug</a>
  </p>

## 🐳 Introduction

Crossbell is an **ownership** **platform** composed of

1. an EVM-compatible blockchain
2. a protocol implemented by a set of smart contracts

Specifically, the information generated from **social activities** will be the initial form of data-ownership by users on Crossbell.

This repository is the implementation of the protocol.

## ⚙ Development

Install forge if you don't have one:
```shell
# install foge
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Compile and run:
```shell
yarn
yarn test
#run single test function using --match-test
forge test --match-test testXXX  -vvvvv
#run single test contract using --match-contract
forge test --match-contract xxxTest  -vvvvv
#run a group of tests using --match-path
forge test --match-path test/...  -vvvvv


```

Deploy:
```shell
npx hardhat run ./scripts/deployXXX.ts
```


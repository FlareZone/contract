// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interface.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    // await hre.run('compile');
    const [owner] = await ethers.getSigners();

    const proxyWeb3Entry = "0xa6f969045641Cf486a747A2688F3a5A6d43cd0D8";
    const xsyncOperator = "0x0F588318A494e4508A121a32B6670b5494Ca3357";

    const NewbieVilla = await ethers.getContractFactory("NewbieVilla");
    const newbieVilla = await NewbieVilla.deploy();
    await newbieVilla.initialize(proxyWeb3Entry, xsyncOperator);

    console.log("newbieVilla deployed to:", newbieVilla.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
import { expect } from "chai";
import { ethers } from "hardhat";
import {
    deployerAddress,
    FIRST_LINKLIST_ID,
    FIRST_PROFILE_ID,
    makeSuiteCleanRoom,
    MOCK_PROFILE_HANDLE,
    MOCK_PROFILE_HANDLE2,
    MOCK_PROFILE_URI,
    SECOND_PROFILE_ID,
    user,
    userAddress,
    userTwo,
    userTwoAddress,
    web3Entry,
} from "../setup.test";
import { makeProfileData, matchEvent } from "../helpers/utils";
import { ERRORS } from "../helpers/errors";

makeSuiteCleanRoom("Profile handle Functionality ", function () {
    context("Generic", function () {
        beforeEach(async function () {
            const profileData = makeProfileData();
            await expect(web3Entry.createProfile(profileData)).to.not.be.reverted;
        });

        context("Scenarios", function () {
            it("User should fail to create profile or set handle with exists handle", async function () {
                const profileData = makeProfileData();
                await expect(web3Entry.createProfile(profileData)).to.be.revertedWith(
                    ERRORS.HANDLE_EXISTS
                );

                await expect(
                    web3Entry.connect(user).setHandle(FIRST_PROFILE_ID, MOCK_PROFILE_HANDLE)
                ).to.be.revertedWith(ERRORS.HANDLE_EXISTS);
            });

            it("User should fail to create profile or set handle with handle length > 31", async function () {
                // create profile
                const handle = "da2423cea4f1047556e7a142f81a7eda";
                const profileData = makeProfileData(handle);
                await expect(web3Entry.createProfile(profileData)).to.be.revertedWith(
                    ERRORS.HANDLE_LENGTH_INVALID
                );

                // set handle
                await expect(
                    web3Entry.connect(user).setHandle(FIRST_PROFILE_ID, handle)
                ).to.be.revertedWith(ERRORS.HANDLE_LENGTH_INVALID);
            });

            it("User should fail to create profile set handle with empty handle", async function () {
                // create profile
                const handle = "";
                const profileData = makeProfileData(handle);
                await expect(web3Entry.createProfile(profileData)).to.be.revertedWith(
                    ERRORS.HANDLE_LENGTH_INVALID
                );

                // set handle
                await expect(
                    web3Entry.connect(user).setHandle(FIRST_PROFILE_ID, handle)
                ).to.be.revertedWith(ERRORS.HANDLE_LENGTH_INVALID);
            });

            it("User should fail to create profile set handle with invalid handle", async function () {
                const arr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()+|[]:",'.split("");
                for (const c of arr) {
                    // create profile
                    const profileData = makeProfileData(c);
                    await expect(web3Entry.createProfile(profileData)).to.be.revertedWith(
                        ERRORS.HANDLE_CONTAINS_INVALID_CHARS
                    );

                    // set handle
                    await expect(
                        web3Entry.connect(user).setHandle(FIRST_PROFILE_ID, c)
                    ).to.be.revertedWith(ERRORS.HANDLE_CONTAINS_INVALID_CHARS);
                }
            });

            it("User should create profile set handle with handle length == 31", async function () {
                const profileData = makeProfileData("_ab2423cea4f1047556e7a14-f1.eth");
                await expect(web3Entry.createProfile(profileData)).to.not.be.reverted;

                await expect(
                    web3Entry
                        .connect(user)
                        .setHandle(FIRST_PROFILE_ID, "_ab2423cea4f1047556e7a14-f1.btc")
                ).to.not.be.reverted;
            });
        });
    });
});
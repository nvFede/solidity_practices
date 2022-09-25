const { expect } = require("chai");
const { ethers } = require("hardhat");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Event Tickets Contract Testing...\n", function () {

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployContractFixture() {
        // Get the ContractFactory and Signers here.
        const MessageContract = await ethers.getContractFactory("EventTickets");
        const [owner, addr1, addr2] = await ethers.getSigners();

        // To deploy our contract, we just have to call Token.deploy() and await
        // its deployed() method, which happens onces its transaction has been
        // mined.
        const deployedContract = await MessageContract.deploy();

        await deployedContract.deployed();

        // Fixtures can return anything you consider useful for your tests
        return { MessageContract, deployedContract, owner, addr1, addr2 };
    }

    describe("Deployment", () => {
        it("Check if the contract deploys successfully\n", async function () {
            const { deployedContract } = await loadFixture(deployContractFixture);
            expect(deployedContract.address).to.be.a.properAddress;
        });
    });
       
});


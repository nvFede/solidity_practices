const { expect } = require("chai");
const { ethers } = require("hardhat");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Private Messages Contract Testing...\n", function () {

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployContractFixture() {
        // Get the ContractFactory and Signers here.
        const MessageContract = await ethers.getContractFactory("Message");
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
        it("Check if the contract deploys successfully", async function () {

            const { deployedContract } = await loadFixture(deployContractFixture);

            expect(deployedContract.address).to.be.not.undefined;
            expect(deployedContract.address).to.be.not.null;
            expect(deployedContract.address).to.be.not.NaN;
            expect(deployedContract.address).to.be.not.equal('');
            expect(deployedContract.address).to.be.not.equal(0x0);

        });
    });
        
    describe("Testing Message Functions", () => {
        it("Owner can set and get a new message", async () => {
          
            const { deployedContract, owner } = await loadFixture(deployContractFixture);

            await deployedContract.setMessage(
                "Hello from Owner!",
                { from: owner.address }
            );

            const message = await deployedContract.viewMessage();
            expect(message).to.be.a('string').and.equal("Hello from Owner!");
            
        });

        it("User can set and get a new message", async () => {

            const { deployedContract, addr1 } = await loadFixture(deployContractFixture);

            await deployedContract.connect(addr1).setMessage(
                "Hello from User 1"
            );

            let userMsg = await deployedContract.connect(addr1).viewMessage();
            expect(userMsg).to.be.a('string').and.equal("Hello from User 1");
        });
        
    });

    describe("Testing Private Message Functions", () => {
        it("Only Owner can set and get a new private message", async () => {

            const { deployedContract, owner } = await loadFixture(deployContractFixture);

            await deployedContract.setPrivateMessage(
                "Hello Private Message from Owner!",
                { from: owner.address }
            );

            const message = await deployedContract.viewPrivateMessage();
            expect(message).to.be.a('string').and.equal("Hello Private Message from Owner!");

        });

        it("User can't set and get a new private message", async () => {

            const { deployedContract, addr1 } = await loadFixture(deployContractFixture);

            // await deployedContract.connect(addr1).setPrivateMessage(
            //     "Hello Private Message from User 1"
            // );
            await expect(deployedContract.connect(addr1)
                .setPrivateMessage("msg")).to.be.revertedWith(
                    "only the owner can perform this action."
                );
           
        });

    });
   
   
   
});


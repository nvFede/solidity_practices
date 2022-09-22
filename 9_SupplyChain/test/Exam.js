const { expect } = require("chai");
const { ethers } = require("hardhat");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Exam Contract Testing...\n", function () {

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployContractFixture() {
        // Get the ContractFactory and Signers here.
        const ExamContract = await ethers.getContractFactory("Exam");
        const [owner, addr1, addr2] = await ethers.getSigners();

        // To deploy our contract, we just have to call Token.deploy() and await
        // its deployed() method, which happens onces its transaction has been
        // mined.
        const deployedContract = await ExamContract.deploy();

        await deployedContract.deployed();

        // Fixtures can return anything you consider useful for your tests
        return { ExamContract, deployedContract, owner, addr1, addr2 };
    }

    describe("Deployment", () => {
        it("Check if the contract deploys successfully\n", async function () {

            const { deployedContract } = await loadFixture(deployContractFixture);

            expect(deployedContract.address).to.be.not.undefined;
            expect(deployedContract.address).to.be.not.null;
            expect(deployedContract.address).to.be.not.NaN;
            expect(deployedContract.address).to.be.not.equal('');
            expect(deployedContract.address).to.be.not.equal(0x0);

        });
    });
        
    describe("Testing Message Functions\n", () => {
        it("Owner can set and get a new message", async () => {
          
            const { deployedContract, owner } = await loadFixture(deployContractFixture);

            await deployedContract.setMessage(
                    "Hello from Owner!"
                ).sign(owner.address);

            const message = await deployedContract.viewMessage();
            expect(message).to.be.a('string').and.equal("Hello from Owner!");
            
        });
        
    });

   
    it("User can set and get a new message", async () => {

        const { deployedContract, addr1 } = await loadFixture(deployContractFixture);

        await deployedContract.setMessage(
            "Hello from User 1"
        ).sign(addr1.address);

        let userMsg = await deployedContract.viewMessage();
        expect(userMsg).to.be.a('string').and.equal("Hello from User 1");


    })
   
});


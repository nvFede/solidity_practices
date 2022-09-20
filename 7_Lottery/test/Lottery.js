const { expect } = require("chai");
const { ethers } = require("hardhat");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Lottery Tickets Contract Testing...", function () {

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployContractFixture() {
        // Get the ContractFactory and Signers here.
        const MessageContract = await ethers.getContractFactory("Lottery");
        const [owner, addr1, addr2, addr3, addr4] = await ethers.getSigners();

        // To deploy our contract, we just have to call Token.deploy() and await
        // its deployed() method, which happens onces its transaction has been
        // mined.
        const deployedContract = await MessageContract.deploy();

        await deployedContract.deployed();

        // Fixtures can return anything you consider useful for your tests
        return { 
            MessageContract, deployedContract, 
            owner, addr1, addr2, addr3, addr4  
        };
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
        
    describe("Lottery Functions Test", () => {
        it("Check the current Lottery Ticket price greater than Zero", async () => {
          
            const { deployedContract, addr1 } = await loadFixture(deployContractFixture);

            const ticketPrice = await deployedContract.viewTicketPrice();
           
            expect(Number(ticketPrice)).to.be.greaterThan(0);
            
        });

        it("A user can buy a Ticket", async () => {
            const { deployedContract, addr1 } = await loadFixture(deployContractFixture);

            const buyTicket = await deployedContract.connect(addr1).buyTicket(
                { value: ethers.utils.parseEther("1") }
            );

            // "The owner can't join the loterry"
           
            expect(buyTicket.value).to.be.not.revertedWith(
                "Please paid the correct amount."
            );
        });

        it("Owner can Pick a winner", async () => {



        });
        
    });

   
});


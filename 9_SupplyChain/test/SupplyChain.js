const { expect } = require("chai");
const { ethers } = require("hardhat");

/* 
    to test functions:
        - addItem ( name, value )
        - buyItem ( by sky number )
        - shipItem ( by sku number )
    to test modifiers: 
        - OnlyOwner
        - forSale 
        - Sold 
        - VerifyCaller 
        - buyerDontOwn 
        - paidEnough
    to test States
        - for sale
        - Sold
        - shipped
*/


// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { BigNumber } = require("ethers");

describe("Supply Chain Contract Testing...\n", function () {

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployContractFixture() {
        // Get the ContractFactory and Signers here.
        const ExamContract = await ethers.getContractFactory("SupplyChain");
        const [owner, client1, client2] = await ethers.getSigners();

        // To deploy our contract, we just have to call Token.deploy() and await
        // its deployed() method, which happens onces its transaction has been
        // mined.
        const deployedContract = await ExamContract.deploy();

        await deployedContract.deployed();

        // Fixtures can return anything you consider useful for your tests
        return { ExamContract, deployedContract, owner, client1, client2 };
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
        
    describe("Testing Supply Chain Functions", () => {
        it("The owner can add a new item for sale", async () => {
          
            const { deployedContract, owner } = await loadFixture(deployContractFixture);

            const newItem = await deployedContract.addItem("iphone", 2000);
                   
            expect(newItem)
                .to.emit("forSaleEvent").withArgs(1)
                .to.emit("newItemAdded").withArgs("iphone", 2000);
        });

        it("Client can view an item from the store", async () => {
            
            const { deployedContract, owner, client1 } = await loadFixture(deployContractFixture);

            const newItem = await deployedContract.addItem("iphone", 2000);

            // string memory name,
            // uint sku,
            // uint price,
            // string memory stateIs, "For Sale"
            // address seller,
            // address buyer

            // expect(await deployedContract.connect(client1).viewItem(1))
            //     .to.deep.equal("iphone", 1, 2000, "For Sale", owner.address, 0x0);

        });

        it("Client can buy an item from the store", async () => {

            const { deployedContract, owner, client1 } = await loadFixture(deployContractFixture);

            const newItem = await deployedContract.addItem("iphone", 2000);

            expect(await deployedContract.connect(client1).buyItem(1, { value: 2000 }))
                .to.changeEtherBalance( client1.address, -2000 )
                .to.emit("soldEvent").withArgs(1);
        });

        it("Seller can Shipped the item once is sold", async() => {
            const { deployedContract, owner, client1 } = await loadFixture(deployContractFixture);

            const newItem = await deployedContract.addItem("iphone", 2000);

            const tx = await  deployedContract.connect(client1).buyItem(1, { value: 2000 });
            
            const shipIt = await deployedContract.shipItem(1);

            expect(shipIt).to.emit("shippedEvent").withArgs(1);

        });
        
    });

    describe("Testing Supply Chain Modifiers", () => {

        it("Reverse if the seller try to buy their own product", async () => {
            const { deployedContract, owner } = await loadFixture(deployContractFixture);

            const newItem = deployedContract.addItem("iphone", 2000);
            const tx = deployedContract.buyItem(1, { value: 2000 });

            await  expect(tx).to.be.revertedWith("You already own this item.");
        });

        it("Revert if the buyer didn't paid Enough for the product", async () => {
            const { deployedContract, owner, client1 } = await loadFixture(deployContractFixture);

            const newItem = await deployedContract.addItem("iphone", 2000);
            const tx = deployedContract.connect(client1).buyItem(1, { value: 1999 });
            await expect(tx).to.be.revertedWith('the offer is too low.');
        });
       
    });

   
});


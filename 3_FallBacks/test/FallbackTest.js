const { expect } = require("chai");
const { ethers } = require("hardhat");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Fallback Contract Testing...", function () {

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployContractFixture() {
        // Get the ContractFactory and Signers here.
        const MessageContract = await ethers.getContractFactory("FallbackTest");
        const [owner, user1] = await ethers.getSigners();

        // To deploy our contract, we just have to call Token.deploy() and await
        // its deployed() method, which happens onces its transaction has been
        // mined.
        const deployedContract = await MessageContract.deploy();

        await deployedContract.deployed();

        // Fixtures can return anything you consider useful for your tests
        return { 
            MessageContract, deployedContract, owner, user1
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
        
    describe("Testing Fallback/receive functions", () => {
        it("Fallback function executed with the corresponding Log event", async () => {
          
            const { deployedContract, owner, user1 } = await loadFixture(deployContractFixture);

            
            let tx = {
                to: deployedContract.address,
                value: ethers.utils.parseEther("1.0")
            };
           
            const transaction = await owner.sendTransaction(tx);
            const rc = await transaction.wait();
            console.log('====================================');
            console.log(rc.events.find(event => event.event === 'Transfer'));
            console.log('====================================');

            // await deployedContract.connect(user1).fallback(tx);
           

            // await deployedContract.fund(true, tx);

            //console.log(tx);
            //await deployedContract.sendTransaction(tx);
            
        });

        it("Receive function executed with the corresponding Log event", async () => {
           
        });

      
        
    });

   
});


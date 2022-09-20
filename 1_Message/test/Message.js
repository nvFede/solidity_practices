const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MESSAGE CONTRACT TESTING...\n", function () {

    const setup = async () => {
        const [owner] = await ethers.getSigners()
        const Message = await ethers.getContractFactory("Message")
        const deployed = await Message.deploy()

        return {
            owner,
            deployed
        }
    }

    describe("Deployment", () => {
        it("Check if the contract deploys successfully\n", async function () {

            const { deployed } = await setup();

            expect(deployed.address).to.be.not.undefined;
            expect(deployed.address).to.be.not.null;
            expect(deployed.address).to.be.not.NaN;
            expect(deployed.address).to.be.not.equal('');
            expect(deployed.address).to.be.not.equal(0x0);
            
        });
    })
   
    describe("Testing Message Functions\n", () => {
        it("Owner can set and get a new message", async () => {
          
            const { deployed } = await setup();
            
            await deployed.setMessage("Hola Mundo!");

            const message = await deployed.viewMessage();
            expect(message).to.be.a('string').and.equal("Hola Mundo!");
            //console.log(`Message: {}`, message);

        })
    })

   

   
});
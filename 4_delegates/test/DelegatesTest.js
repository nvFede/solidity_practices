const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Delegate Contract Testing...\n", function () {
    
    async function deployTokenFixture() {

        const [deployer] = await ethers.getSigners();

        const CallerContract = await ethers.getContractFactory("CallerContract");
        const callercontract = await CallerContract.deploy();
        await callercontract.deployed();
        
        const TargetContractDelegate = await ethers.getContractFactory("TargetContractDelegate");
        const targetcontract = await TargetContractDelegate.deploy();
        await targetcontract.deployed();
       
        return { 
            CallerContract,
            callercontract, 
            TargetContractDelegate, 
            targetcontract, 
            deployer
        }
    }

    describe("Deployment", function() {

        it("Check deployments are valid addresses", async function () {
            const { callercontract, targetcontract, deployer } = await loadFixture(deployTokenFixture);

            console.log('====================================');
            console.log(`Caller contract address: `, callercontract.address);
            console.log('====================================');

            console.log('====================================');
            console.log(`Target contract address: `, targetcontract.address);
            console.log('====================================');

            expect(callercontract.address).to.be.a.properAddress;
            expect(targetcontract.address).to.be.a.properAddress;


        });

        it("can call the target function a pass args", async function() {
            const { callercontract, targetcontract, deployer } = await loadFixture(deployTokenFixture);

            const tx = await callercontract.testDelegateCall(
                "Mensaje", targetcontract.address
                );

            console.log('==========================')
            //console.log(tx);

            const [ userMsg, sender, value ] = await targetcontract.getValues();
            console.log(sender);
        });
    });
});


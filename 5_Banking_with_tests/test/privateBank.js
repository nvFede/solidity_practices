const { expect } = require("chai");
const { ethers } = require("hardhat");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage of Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Private Bank Contract Testing...\n", function () {

    let minimumDeposit = 10;
    let BANK_ADDRESS;
    let client1_addr;
    let client2_addr;
    let client3_addr;
    let client4_addr;
    let client5_addr;

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployContractFixture() {
        // Get the ContractFactory and Signers here.
        const BankContract = await ethers.getContractFactory("privateBank");
        const [bankManager, client1, client2, client3, client4, client5] = await ethers.getSigners();

        // To deploy our contract, we just have to call Token.deploy() and await
        // its deployed() method, which happens onces its transaction has been
        // mined.
        const deployedContract = await BankContract.deploy();

        await deployedContract.deployed();

       

        // Fixtures can return anything you consider useful for your tests
        return { BankContract, deployedContract, bankManager, client1, client2, client3, client4, client5 };
    }

    describe("Bank Data", async () => {
        const { deployedContract, bankManager, client1, client2, client3, client4, client5 } = await loadFixture(deployContractFixture);
        console.log("      ==========================================================\n");
        console.log(`      - Bank Address:         `, deployedContract.address);
        console.log(`      - Bank Manager Address: `, bankManager.address);
        console.log(`      - Client 1 Address:     `, client1.address);
        console.log(`      - Client 2 Address:     `, client2.address);
        console.log(`      - Client 3 Address:     `, client3.address);
        console.log(`      - Client 4 Address:     `, client4.address);
        console.log(`      - Client 5 Address:     `, client5.address);
        console.log("      ==========================================================\n");
    });
        
    describe("Testing Bank Functions\n", () => {
        it("Client can enroll to the bank filling the minimum deposit (fire event newClientEnrolled)", async () => {
          
            const valueToDeposit = ethers.utils.parseEther(minimumDeposit.toString());

            const { deployedContract, client1 } = await loadFixture(deployContractFixture);

            const transaction = await deployedContract.enrollClient(
                { value: valueToDeposit}
                );
            const accountBalance = await deployedContract.checkAccountBalance();
            
            expect(accountBalance).to.be.equal(valueToDeposit).to.emit("newClientEnrolled");;
        });

        it("Client can deposit funds to his account (fire event fundsDeposited)", async () => {

            const firstDeposit = ethers.utils.parseEther('12');
            const secondDeposit = ethers.utils.parseEther('3');
            const thirdDeposit = ethers.utils.parseEther('5');

            const { deployedContract, client1 } = await loadFixture(deployContractFixture);

            const transaction1 = await deployedContract.enrollClient(
                { value: firstDeposit }
            );

            const transaction2 = await deployedContract.depositFunds(
                { value: secondDeposit }
            );
            const transaction3 = await deployedContract.depositFunds(
                { value: thirdDeposit }
            );

            const accountBalance = await deployedContract.checkAccountBalance();
            expect(accountBalance).to.be.equal(
                ethers.utils.parseEther('20')
            ).to.emit("fundsDeposited");
            
        });

        it("client can withdraw funds from his account (fire event withdrawal done)", async() => {

            const firstDeposit = ethers.utils.parseEther('12');
            const secondDeposit = ethers.utils.parseEther('3');
            const thirdDeposit = ethers.utils.parseEther('5');

            const { deployedContract, client1 } = await loadFixture(deployContractFixture);

            const transaction1 = await deployedContract.connect(client1).enrollClient(
                { value: firstDeposit }
            );

            const transaction2 = await deployedContract.connect(client1).depositFunds(
                { value: secondDeposit }
            );
            const transaction3 = await deployedContract.connect(client1).depositFunds(
                { value: thirdDeposit }
            );

            
            //await expect(withdrawTx).to.emit('withdrawalDone');
            //console.log(await deployedContract.connect(client1).checkAccountBalance());
            console.log(await deployedContract.address);
            
            const withdrawTx = await deployedContract.connect(client1).withdrawFunds(firstDeposit);
            
            //console.log(await deployedContract.connect(client1).checkAccountBalance());



        });
        
    });

   
});


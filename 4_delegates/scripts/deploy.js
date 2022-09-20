async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const CallerContract = await ethers.getContractFactory("CallerContract");
    const callercontract = await CallerContract.deploy();

    console.log("CallerContract address:", callercontract.address);

    const TargetContractDelegate = await ethers.getContractFactory("TargetContractDelegate");
    const targetcontract = await TargetContractDelegate.deploy();

    console.log("TargetContractDelegate address:", targetcontract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
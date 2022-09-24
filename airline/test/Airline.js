const AirlineContract = artifacts.require("Airline")

//
let airline;

// unit from wei - convertions
const WEI = 1;
const BABBAGE = 10**3;
const LOVELACE = 10**6;
const SHANNON = 10**9;
const SZABO = 10**12;
const FINNEY = 10**15;
const ETHER = 10**18;

console.log("-------------------------------");


contract("Airline", (accounts) => {

    const airlineOwner = accounts[0];
    const client1 = accounts[1];
    const client2 = accounts[2];
    const client3 = accounts[3];    

    beforeEach( async() => {
        this.Airline = await AirlineContract.deployed()
        airline = await AirlineContract.new()
    })

    it("deploys correctly", async() => {
        const contractAddr = this.Airline.address
        assert.notEqual(contractAddr, 0x0)
        assert.notEqual(contractAddr, '')
        assert.notEqual(contractAddr, null)
        assert.notEqual(contractAddr, undefined)
    })      


    it("The airline can add a new flight", async () =>{
        const newFlight = await airline.addFlight(
            "Madrid", "Barcelona", FINNEY
        )
        assert.exists("FlightAdded")
    })

    it("Fail if someone else tries to add a new flight", async () => {

        let reverted = false;
        try {
            await airline.addFlight(
                "Madrid", "Barcelona", FINNEY, { from: client1 }
            )
        } catch(e) {
            reverted = true
        }
        assert.equal(reverted, true, "caller is not the owner")
    })

    it("Client can purchase a flight", async () => {
        try {
            const newFlight = await airline.addFlight(
                "Madrid", "Barcelona", FINNEY
            )
        } catch (error) {
            console.log(error)
        }
        
        try {
            await airline.buyFlight(0, {
                from: client1, value: FINNEY
            })
        } catch(e) {
            console.log(e)
        }

        let flight = await airline.flights(0);
        let origin = flight[0];
        let price = flight[2];

        let clientTotalFlights = await airline.clientTotalFlights(client1)
        let clientFlight = await airline.clientsFlights(client1, 0)


        assert(clientTotalFlights, 1)
        assert(clientFlight[0], origin)

    })

    it("Client can't purchase a flight under the price", async () => {
        try {
            const newFlight = await airline.addFlight(
                "Madrid", "Barcelona", FINNEY
            )
        } catch (error) {
            console.log(error)
        }

        try {
            await airline.buyFlight(0, {
                from: client1, value: BABBAGE
            })
        } catch (e) {
            return;
        }

        let flight = await airline.flights(0);
        let origin = flight[0];
        let price = flight[2];

        let clientTotalFlights = await airline.clientTotalFlights(client1)
        let clientFlight = await airline.clientsFlights(client1, 0)

        assert.fail()

    })

    it("Get the total number of flight available", async()=> {
        try {
            await airline.addFlight("Madrid", "Barcelona", FINNEY)
            await airline.addFlight("Madrid", "Berlin", 2*FINNEY)
            await airline.addFlight("Lisboa", "Roma", 3*FINNEY)
        } catch (error) {
            console.log(error)
        }
        let totalFlights = await airline.gettTotalFlights()

        assert.equal(totalFlights,3)
    })

    it("Should get the real airline balance", async () => {
        try {
            await airline.addFlight("Madrid", "Barcelona", FINNEY)
            await airline.addFlight("Madrid", "Berlin", 2 * FINNEY)
            await airline.addFlight("Lisboa", "Roma", 3 * FINNEY)
        } catch (error) {
            console.log(error)
        }
        try {
            await airline.buyFlight(0, {
                from: client1, value: FINNEY
            })
            await airline.buyFlight(1, {
                from: client1, value: 2 * FINNEY
            })
            await airline.buyFlight(2, {
                from: client1, value: 3 * FINNEY
            })
        } catch (e) {
            console.log(e)
        }
    

        let flight1 = await airline.flights(0)
        let price1 = flight1[3]
        let flight2 = await airline.flights(1)
        let price2 = flight2[3]
        let flight3 = await airline.flights(2)
        let price3 = flight3[3]

        let airlineBalance = await airline.getAirlineBalance()


        assert.equal(
            Number(airlineBalance),
            Number(price1) + Number(price2) + Number(price3)
        )

    })

    it("should allow client to redeem loyalty points", async () => {
        try {
            const newFlight = await airline.addFlight(
                "Madrid", "Barcelona", FINNEY
            )
        } catch (error) {
            console.log(error)
        }

        try {
            await airline.buyFlight(0, {
                from: client1, value: BABBAGE
            })
        } catch (e) {
            return;
        }

        let flight = await airline.flights(0);
        let origin = flight[0];
        let price = flight[3];

        let initialBalance = await web3.eth.getBalance(client1)
        await airline.redeemLoyaltyPoints({from: client1})
        let finalBalance = await web3.eth.getBalance(client1)

        let currentClient = await airline.clients(client1)
        let loyalPts = currentClient[1]

        assert(loyalPts, 0)
        assert(finalBalance>initialBalance)

    })

})
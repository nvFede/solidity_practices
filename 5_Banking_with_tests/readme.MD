# Private Bank Solidity Contract with tests 

A private bank that accept deposits and withdrawals

Solidity features:

- mappings
- modifiers  
- events


## Tests



    Private Bank Contract Testing...

    Testing Bank Functions

      ==========================================================

      - Bank Address:          0x5FbDB2315678afecb367f032d93F642f64180aa3
      - Bank Manager Address:  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
      - Client 1 Address:      0x70997970C51812dc3A010C7d01b50e0d17dc79C8
      - Client 2 Address:      0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
      - Client 3 Address:      0x90F79bf6EB2c4f870365E785982E1f101E93b906
      - Client 4 Address:      0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65
      - Client 5 Address:      0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc
      ==========================================================

      ✔ Client can enroll to the bank filling the minimum deposit (fire event newClientEnrolled) (777ms)
      ✔ Client can deposit funds to his account (fire event fundsDeposited) (148ms)
      ✔ client can withdraw funds from his account (fire event withdrawal done) (185ms)
      ✔ Client can close his account (118ms)


  4 passing (2s)

### Technologies

* [Solidity](https://solidity-es.readthedocs.io/es/latest/)
* [Hardhat](https://hardhat.org/)
* [Chai](https://www.chaijs.com/api/bdd/)

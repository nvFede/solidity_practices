# Supply Chain Contract with tests 

A supply chain for a store that sell products.

## Tests

Supply Chain Contract Testing...

    Deployment
      ✔ Check if the contract deploys successfully (2463ms)
    Testing Supply Chain Functions
      ✔ The owner can add a new item for sale (87ms)
      ✔ Client can view an item from the store (97ms)
      ✔ Client can buy an item from the store (100ms)
      ✔ Seller can Shipped the item once is sold (111ms)
    Testing Supply Chain Modifiers
      ✔ Reverse if the seller try to buy their own product (102ms)
      ✔ Revert if the buyer didn't paid Enough for the product (68ms)


### Technologies

* [Solidity](https://solidity-es.readthedocs.io/es/latest/)
* [Hardhat](https://hardhat.org/)
* [Chai](https://www.chaijs.com/api/bdd/)

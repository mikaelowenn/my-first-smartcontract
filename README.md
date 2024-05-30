## Foundry Fund Me

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**
Welcome to my GitHub repository for Foundry Fund Me! This project showcases my first portfolio for Smart Contract Development using Foundry, a blazing fast, portable, and modular toolkit for Ethereum application development written in Rust
## Foundry consists of several powerful toolss:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

Comprehensive documentation for Foundry can be found [here](https://book.getfoundry.sh/).

## Usage

### Build

Compile your smart contracts using:
```shell
$ forge build
```

### Test
Run tests on your smart contracts with:
```shell
$ forge test
```

### Format
Format your Solidity code to maintain consistency:
```shell
$ forge fmt
```

### Gas Snapshots
Generate gas snapshots for your contracts to analyze gas usage:
```shell
$ forge snapshot
```

### Anvil
Generate gas snapshots for your contracts to analyze gas usage:
```shell
$ anvil
```

### Deploy
Deploy your smart contract using a script:
```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast
Use Cast for various Ethereum-related operations:
```shell
$ cast <subcommand>
```

### Help
Need Help?
```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Contribution
Feel free to fork this repository, submit issues, and make pull requests. Contributions are welcome!
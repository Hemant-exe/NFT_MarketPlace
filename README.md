
# NFT Marketplace

A decentralized platform where users can create, buy, sell, and list NFTs seamlessly. This project leverages blockchain technology to ensure authenticity, transparency, and secure ownership of digital assets.

## Features

- **NFT Creation:** Mint your own NFTs.
- **NFT Listing:** List your NFTs for sale on the marketplace.
- **Buy & Sell:** Securely transact and exchange NFTs.
- **Decentralized Ownership:** Transactions are recorded on the blockchain, ensuring transparency.

## Tech Stack

- **Next.js:** React framework for building the front-end.
- **Hardhat:** Development environment for compiling, testing, and deploying smart contracts.
- **web3.js:** JavaScript library for interacting with the Ethereum blockchain.
- **Solidity:** Language used to write smart contracts.
- **Ethereum:** The blockchain network where the smart contracts are deployed.

## Installation

1. **Clone the Repository**
   ```bash
   https://github.com/Hemant-exe/NFT_MarketPlace.git
   cd NFT_MarketPlace


2. **Install Front-End Dependencies**
    
    ```bash
    cd client
    npm install
    
    ```
    
3.  **Install Smart Contract Dependencies**
    
    ```bash
    cd ../contracts
    npm install
    
    ```
    
4.  **Environment Configuration**
    
    -   Create a `.env` file in both the `client` and `contracts` directories with your configuration (RPC URLs, private keys, API keys, etc.).

## Smart Contract Deployment

1.  **Compile Contracts**
    
    ```bash
    npx hardhat compile
    
    ```
    
2.  **Deploy Contracts**
    
    ```bash
    npx hardhat ignition deploy ./ignition/modules/Lock.js --network <network_name>
    
    ```
    

## Running the Application

1.  **Start the Front-End**
    
    ```bash
    cd client
    npm run dev
    
    ```
    
2.  Open your browser and navigate to `http://localhost:3000`.

## Usage

-   **Create NFT:** Use the interface to mint a new NFT.
-   **List NFT:** List your minted NFT for sale.
-   **Buy/Sell NFT:** Browse and purchase available NFTs using your Ethereum wallet.
-   **View Details:** Click on an NFT to see its details and transaction history.

## Testing

Run the smart contract tests using Hardhat:

```bash
npx hardhat test

```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you encounter any problems or have suggestions for improvement.

## License

This project is licensed under the [MIT License](https://chatgpt.com/c/LICENSE).

## Contact

For any questions or support, please contact hemant17052002@gmail.com or open an issue in the repository.


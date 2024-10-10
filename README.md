# 🌟 StarPlayers - Football Player NFT Collection 🌟

**StarPlayers** is an exclusive football player NFT collection, where users can mint specific player cards or purchase a mystery box 🎁 to randomly obtain a player card. This project was developed as part of the Mobiup bootcamp and is built using the ERC-721 standard. The collection includes different player types, such as forwards, midfielders, and defenders, each with unique attributes and limited supply.

## ✨ Features

- **Mint Specific Player Cards**: Users can mint cards for specific players by selecting a type and paying the corresponding mint price 🏆.
- **Mystery Box**: Users can purchase a mystery box to receive a randomly selected player card 🎲.
- **Royalty Support**: This contract supports the ERC2981 standard, ensuring a 5% royalty on secondary sales 💸.
- **Unique Metadata**: Each NFT includes metadata such as the player's position, club, age, and skill level ⚽.

## 📂 Project Structure

- **Contracts**: The main contract, `StarPlayers`, is an ERC721 token that represents the player cards.
- **Player Struct**: Each player type has attributes like `currentSupply`, `maxSupply`, `mintPrice`, and `baseURI`.
- **Randomized Minting**: Mystery box minting includes a random selection mechanism to determine the player type 🔄.

## 🚀 Deployment

The contract is deployed on the Amoy testnet 🌐. Ensure you have test MATIC for minting or purchasing the mystery box.

## 🛠 Tech Stack

- **Solidity**: For smart contract development.
- **OpenZeppelin**: Utilized for ERC721 token and ownership functionalities.
- **Pinata**: Used for storing metadata and images on IPFS.

## 📜 Contract Details

- **Royalty Fee**: 5% on all secondary sales 💵.
- **Mint Prices**: Range from 0.001 to 0.01 MATIC depending on player type.
- **Max Supply**: Each player type has a maximum number of NFTs that can be minted.

## 🎮 How to Use

1. **Mint a Specific Player**:
   - Call `mint(uint8 typeId)` with the appropriate MATIC to mint a specific player type 💰.
2. **Purchase a Mystery Box**:
   - Call `mintMysteryBox()` with 0.005 MATIC to receive a randomly selected player card 🃏.

## 📄 License

This project is licensed under the MIT License 📑.

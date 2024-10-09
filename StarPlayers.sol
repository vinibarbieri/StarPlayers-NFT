// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StarPlayers is ERC721, Ownable {
    struct NFTType {
        uint8 currentSupply;
        uint8 maxSupply;
        uint256 mintPrice;
        string baseURI;
    }

    mapping(uint8 => NFTType) public nftTypes;
    mapping(uint8 => uint8) public tokenType;

    uint8 public nextTokenId;

    error SupplyExceeded(uint8 typeId);
    error InsufficientValue(uint256 required, uint256 sent);
    error FailedToFindAValidType();

    event NFTCreated(uint8 indexed tokenId, uint8 indexed typeId, address indexed to);

    constructor() ERC721("StarPlayers", "STAR") Ownable(msg.sender) {
        nftTypes[1] = NFTType({
            currentSupply: 0,
            maxSupply: 10,
            mintPrice: 0.01 ether,
            baseURI: "https://gateway.pinata.cloud/ipfs/QmQK2n27R2Hisi9QQcoso2sMM8i2Tjyn6d5LZwKs8aXHkF/"
        });
        nftTypes[2] = NFTType({
            currentSupply: 0,
            maxSupply: 30,
            mintPrice: 0.007 ether,
            baseURI: "https://gateway.pinata.cloud/ipfs/QmQVCBEMCwRHNC9F4wfGYutacJnxPi8Q1cPtuRoJpnc37B/"
        });
        nftTypes[3] = NFTType({
            currentSupply: 0,
            maxSupply: 50,
            mintPrice: 0.001 ether,
            baseURI: "https://gateway.pinata.cloud/ipfs/QmUCqj5RysXZKiX5XJXMjTguqAAgWc8Ce3u6h2iXNbq4RX/"
        });

        nextTokenId = 1;
    }

    function mintMysteryBox() external payable {
        uint256 mysteryBoxPrice = 0.005 ether;
        require(msg.value >= mysteryBoxPrice, "Insufficient payment for mystery box");

        uint8 typeId = getRandomType();
        NFTType storage nftType = nftTypes[typeId];

        require(nftType.currentSupply < nftType.maxSupply, "All NFTs of this type have been minted");

        // Mint do token
        uint8 tokenId = nextTokenId++;
        _safeMint(msg.sender, tokenId);
        nftType.currentSupply += 1;
        tokenType[tokenId] = typeId;

        emit NFTCreated(tokenId, typeId, msg.sender);
    }

    function getRandomType() internal view returns (uint8) {
        uint8 totalSupplyRemaining = 0;
        for (uint8 i = 1; i <= 3; i++) {
            totalSupplyRemaining += (nftTypes[i].maxSupply - nftTypes[i].currentSupply);
        }

        // Generate a number between 0 and (totalSupplyRemaining - 1)
        uint256 randomValue = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % totalSupplyRemaining;

        uint8 cumulativeSum = 0;
        for (uint8 i = 1; i <= 3; i++) {
            uint8 supplyRemaining = nftTypes[i].maxSupply - nftTypes[i].currentSupply;
            cumulativeSum += supplyRemaining;
            
            if (randomValue < cumulativeSum) {
                return i;
            }
        }
        revert FailedToFindAValidType();
    }


    function mint(uint8 typeId) external payable {
        NFTType storage nftType = nftTypes[typeId];
        require(nftType.maxSupply > 0, "NFT type does not exist");
        require(nftType.currentSupply < nftType.maxSupply, "Max supply reached for this type");

        // Verification of the payment
        if (msg.value < nftType.mintPrice) revert InsufficientValue(nftType.mintPrice, msg.value);

        // Token Mint
        uint8 tokenId = nextTokenId++;
        _safeMint(msg.sender, tokenId);
        nftType.currentSupply += 1;
        tokenType[tokenId] = typeId;

        emit NFTCreated(tokenId, typeId, msg.sender);
    }

    function setBaseURI(uint8 typeId, string memory baseURI) external onlyOwner {
        nftTypes[typeId].baseURI = baseURI;
    }

    function setMintPrice(uint8 typeId, uint256 mintPrice) external onlyOwner {
        nftTypes[typeId].mintPrice = mintPrice;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        uint8 typeId = tokenType[uint8(tokenId)];
        NFTType storage nftType = nftTypes[typeId];
        return string(abi.encodePacked(nftType.baseURI, nftTypeToTokenNumber(uint8(tokenId), typeId), ".json"));
    }


    function nftTypeToTokenNumber(uint8 tokenId, uint8 typeId) internal view returns (string memory) {
        uint256 tokenNumber = tokenId - nftTypeStartingId(typeId);
        return Strings.toString(tokenNumber + 1); // +1 to start with #1
    }

    function nftTypeStartingId(uint8 typeId) internal view returns (uint8) {
        uint8 startingId = 1; 
        for (uint8 i = 1; i < typeId; i++) {
            startingId += nftTypes[i].maxSupply;
        }
        return startingId;
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

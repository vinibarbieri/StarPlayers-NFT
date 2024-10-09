// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StarPlayers is ERC721URIStorage, ERC721Enumerable, Ownable {
    uint256 public tokenCounter; // Contador de NFT criados
    string public contractURI = "https://green-total-felidae-639.mypinata.cloud/ipfs/QmZANaEXzD65hfABwRMJCA52m4injWbqHER9jX4QeqBcyt";  // Variável para armazenar o URI do contrato
    string public nftTokenURI = "https://green-total-felidae-639.mypinata.cloud/ipfs/QmWGTAoNLL7a2WDGQBqUMkPV6mS6hrkAMRNTr21fa9i4S4";
    uint16 public supply = 200;
    uint256 public mintPrice = 0.05 ether;
    uint16 public royaltyFee = 500;
    address public royaltyRecipient = owner();

    mapping(address => uint256) public addressMintedBalance;
    uint256 public maxMintAmount = 5;

    event NFTCreated(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("StarPlayers", "STAR") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function createNFT(address to, string memory tokenURI) public payable {
        // Arrumar os erros
        require(addressMintedBalance[to] < maxMintAmount, "Mint limit reached for this address");
        require(msg.value >= mintPrice, "Insuficient value to mint the NFT");
        require(tokenCounter < supply, "All NFTs minteds");

        tokenCounter += 1;
        uint256 newTokenId = tokenCounter;
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, nftTokenURI);
        addressMintedBalance[to] += 1;

        emit NFTCreated(to, newTokenId);
    }

    function withdraw() public onlyOwner {
        // Trocar o transfer
        payable(owner()).transfer(address(this).balance);
    }

    // Função para atualizar o contractURI se necessário
    function setContractURI(string memory _contractURI) public onlyOwner {
        contractURI = _contractURI;
    }

    function yoyaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
        royaltyAmount = (_salePrice * royaltyFee) / 10000;
        return (royaltyRecipient, royaltyAmount);
    }

    function setRoyaltyFee(uint16 _fee) public onlyOwner {
        require(_fee <= 1000, "The max tax is 10%");
        royaltyFee = _fee;
    }

    function burn(uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "You dont have this token");
        _burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721URIStorage, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

}
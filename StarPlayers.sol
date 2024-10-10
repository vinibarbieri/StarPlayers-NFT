// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract StarPlayers is ERC721, IERC2981, Ownable {
    struct Player {
        uint8 currentSupply;
        uint8 maxSupply;
        uint256 mintPrice;
        string baseURI;
    }

    mapping(uint8 => Player) public players;
    mapping(uint8 => uint8) public tokenType;
    mapping(uint8 => uint8) public typeTokenCount;
    mapping(uint256 => uint8) public tokenPositionInType;

    uint8 public nextTokenId;
    uint256 public royaltyFee = 500;
    address public royaltyRecipient = 0xd2d0E25AA617bd5DC5Db97F066c88E4AB929b532;
    string public contractURI;

    error SupplyExceeded(uint8 typeId);
    error WrongValue(uint256 required, uint256 sent);
    error InvalidType();
    error TransferFailed();

    event NFTCreated(uint8 indexed tokenId, uint8 indexed typeId, address indexed to);

    constructor(string memory _contractURI, address _royaltyRecipient) ERC721("StarPlayers", "STAR") Ownable(msg.sender) {
        contractURI = _contractURI;
        royaltyRecipient = _royaltyRecipient;

        players[1] = Player({
            currentSupply: 0,
            maxSupply: 10,
            mintPrice: 0.01 ether,
            baseURI: "https://green-total-felidae-639.mypinata.cloud/ipfs/QmbDYXCqQUetMbXMG2FJhTtu8hWjWMnANY1dQE54vmZhe4/"
        });
        players[2] = Player({
            currentSupply: 0,
            maxSupply: 30,
            mintPrice: 0.007 ether,
            baseURI: "https://green-total-felidae-639.mypinata.cloud/ipfs/Qme5FSo2n5iMCus8R5VMETFQkuWsTvajKAD7FGYeVGyH7Z/"
        });
        players[3] = Player({
            currentSupply: 0,
            maxSupply: 50,
            mintPrice: 0.001 ether,
            baseURI: "https://green-total-felidae-639.mypinata.cloud/ipfs/QmUgDJiVFyw5n8txgyC2EjtPSGTHP5yiG2wajXpKa8iSsL/"
        });

        nextTokenId = 1;
    }

    function mintMysteryBox() external payable {
        uint256 mysteryBoxPrice = 0.005 ether;
        if (msg.value != mysteryBoxPrice) revert WrongValue(mysteryBoxPrice, msg.value);

        uint8 typeId = getRandomType();
        Player storage player = players[typeId];

        if (player.currentSupply >= player.maxSupply) revert SupplyExceeded(typeId);

        _mintToken(typeId);
    }

    function mint(uint8 typeId) external payable {
        Player storage player = players[typeId];
        if (player.maxSupply == 0) revert InvalidType();
        if (player.currentSupply >= player.maxSupply) revert SupplyExceeded(typeId);
        if (msg.value != player.mintPrice) revert WrongValue(player.mintPrice, msg.value);

        _mintToken(typeId);
    }

    function _mintToken(uint8 typeId) internal {
        Player storage player = players[typeId];
        uint8 tokenId = nextTokenId++;

        player.currentSupply += 1;
        typeTokenCount[typeId] += 1;
        tokenPositionInType[tokenId] = typeTokenCount[typeId];

        _safeMint(msg.sender, tokenId);
        tokenType[tokenId] = typeId;

        emit NFTCreated(tokenId, typeId, msg.sender);
    }


    function getRandomType() internal view returns (uint8) {
        uint8 totalSupplyRemaining = 0;
        for (uint8 i = 1; i <= 3; i++) {
            totalSupplyRemaining += (players[i].maxSupply - players[i].currentSupply);
        }

        uint256 randomValue = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % totalSupplyRemaining;

        uint8 cumulativeSum = 0;
        for (uint8 i = 1; i <= 3; i++) {
            cumulativeSum += (players[i].maxSupply - players[i].currentSupply);
            if (randomValue < cumulativeSum) {
                return i;
            }
        }
        revert("Logic error: failed to find a valid type");
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        uint8 typeId = tokenType[uint8(tokenId)];
        Player storage player = players[typeId];
        uint8 relativeTokenNumber = tokenPositionInType[tokenId];

        return string(abi.encodePacked(player.baseURI, Strings.toString(relativeTokenNumber), ".json"));
    }


    function royaltyInfo(uint256, uint256 salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
        royaltyAmount = (salePrice * royaltyFee) / 10000;
        return (royaltyRecipient, royaltyAmount);
    }

    function getRelativeTokenNumber(uint256 tokenId) public view returns (uint8) {
        return tokenPositionInType[tokenId];
    }
 
    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        if (!success) revert TransferFailed();
    }
}

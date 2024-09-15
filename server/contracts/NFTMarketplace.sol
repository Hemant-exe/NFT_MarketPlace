// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTMarketplace is ERC721URIStorage {
    uint256 private tokenid = 0;
    uint256 private itemsSold = 0;
    uint256 ListingPrice = 0.025 ether;

    address payable owner;
    mapping(uint256 => MarketItems) IdMarketItems;

    struct MarketItems {
        uint256 tokenid;
        address payable seller;
        address payable owner;
        uint price;
        bool sold;
    }

    event IdMarketItemsCreated(
        uint256 tokenid,
        address seller,
        address owner,
        uint price,
        bool sold
    );
    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner can call this function ");
        _;
    }

    constructor() ERC721("NFT Metaverse Token", "NFTMT") {
        tokenid = 0;
        owner = payable(msg.sender);
    }

    function updateListingPrice(uint price) public payable onlyOwner {
        ListingPrice = price;
    }

    function getListingPrice() public view returns (uint256) {
        return ListingPrice;
    }

    //create making nft token
    function createToken(
        string memory _tokenURI,
        uint256 price
    ) public payable returns (uint256) {
        require(price > 0, "Price must be at least 1 wei");
        tokenid += 1;
        uint256 currentTokenId = tokenid;
        _mint(msg.sender, currentTokenId);
        _setTokenURI(currentTokenId, _tokenURI);

        createMarketItem(currentTokenId, price);

        return currentTokenId;
    }

    //creating market item
    function createMarketItem(uint256 tokenid, uint256 price) private {
        require(price > 0, "price must be greater than zero");
        require(
            msg.value >= ListingPrice,
            "balance must be grater than or equal to listing price"
        );
        IdMarketItems[tokenid] = MarketItems(
            tokenid,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );
        _transfer(msg.sender, address(this), tokenid);
        emit IdMarketItemsCreated(
            tokenid,
            msg.sender,
            address(this),
            price,
            false
        );
    }

    //function to resell the token

    function reSellToken(
        uint256 tokenid,
        uint256 price
    ) public payable returns (uint256) {
        require(
            IdMarketItems[tokenid].owner == msg.sender,
            "Only owner can sell token "
        );
        require(
            msg.value == ListingPrice,
            "owner should have atleast listinig price "
        );
        require(price > 0, "price must be greater than zero");

        IdMarketItems[tokenid].sold = false;
        IdMarketItems[tokenid].seller = payable(address(msg.sender));
        IdMarketItems[tokenid].price = price;
        IdMarketItems[tokenid].owner = payable(address(this));

        itemsSold -= 1;

        _transfer(msg.sender, address(this), tokenid);
    }

    function CreateMarketSale(uint256 tokenid) public payable {
        uint256 price = IdMarketItems[tokenid].price;

        require(
            msg.value == price,
            "please submit asking price to call this function "
        );
        require(
            IdMarketItems[tokenid].owner == address(this),
            "only owner can sell token"
        );

        IdMarketItems[tokenid].owner = payable(msg.sender);
        IdMarketItems[tokenid].sold = true;
        IdMarketItems[tokenid].owner = payable(address(0));
        itemsSold += 1;

        _transfer(address(this), msg.sender, tokenid);
        payable(owner).transfer(ListingPrice); // check
        payable(IdMarketItems[tokenid].seller).transfer(msg.value);
    }

    function fetchMarketItem() public view returns (MarketItems[] memory) {
        uint256 itemCount = tokenid;
        uint256 unsoldItemCount = tokenid - itemsSold;
        uint256 index = 0;
        MarketItems[] memory items = new MarketItems[](unsoldItemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            if (IdMarketItems[i + 1].owner != address(this)) {
                items[index] = IdMarketItems[i + 1];
                index++;
            }
        }
        return items;
    }

    function fetchMyNFT() public view returns (MarketItems[] memory) {
        uint256 totalCount = tokenid;
        uint256 itemCount = 0;
        uint256 index = 0;
        for (uint i = 0; i < totalCount; i++) {
            if (IdMarketItems[i + 1].owner == msg.sender) {
                itemCount++;
            }
        }

        MarketItems[] memory items = new MarketItems[](itemCount);

        for (uint i = 0; i < totalCount; i++) {
            if (IdMarketItems[i + 1].owner == msg.sender) {
                items[index] = IdMarketItems[i + 1];
                index++;
            }
        }
        return items;
    }

    function fetchListedNFT() public view returns (MarketItems[] memory) {
        uint256 totalCount = tokenid;
        uint256 itemCount = 0;
        uint256 index = 0;

        for (uint i = 0; i < totalCount; i++) {
            if (IdMarketItems[i + 1].seller == msg.sender) {
                itemCount++;
            }
        }

        MarketItems[] memory items = new MarketItems[](itemCount);
        for (uint i = 0; i < totalCount; i++) {
            items[index] = IdMarketItems[i + 1];
            index++;
        }

        return items;
    }
}

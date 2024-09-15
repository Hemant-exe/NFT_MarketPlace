const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("NFTMarketplace", function () {
  async function deployMarketplaceFixture() {
    const ListingPrice = ethers.utils.parseUnits("0.025", 18);

    const [owner, seller, buyer] = await ethers.getSigners();

    const Marketplace = await ethers.getContractFactory("NFTMarketplace");
    const marketplace = await Marketplace.deploy();

    await marketplace.deployed();

    return { marketplace, ListingPrice, owner, seller, buyer };
  }

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      const { marketplace, owner } = await loadFixture(
        deployMarketplaceFixture
      );
      expect(await marketplace.owner()).to.equal(owner.address);
    });

    it("Should set the correct listing price", async function () {
      const { marketplace, ListingPrice } = await loadFixture(
        deployMarketplaceFixture
      );
      expect(await marketplace.getListingPrice()).to.equal(ListingPrice);
    });
  });

  describe("Creating and Selling NFTs", function () {
    it("Should create a token and list it on the marketplace", async function () {
      const { marketplace, ListingPrice, seller } = await loadFixture(
        deployMarketplaceFixture
      );

      const tokenURI = "https://example.com/nft";
      const price = ethers.utils.parseUnits("1", 18);

      await marketplace
        .connect(seller)
        .createToken(tokenURI, price, { value: ListingPrice });

      const marketItem = await marketplace.IdMarketItems(1);
      expect(marketItem.seller).to.equal(seller.address);
      expect(marketItem.price).to.equal(price);
      expect(marketItem.sold).to.equal(false);
    });

    it("Should not allow creating a token with zero price", async function () {
      const { marketplace, ListingPrice, seller } = await loadFixture(
        deployMarketplaceFixture
      );
      const tokenURI = "https://example.com/nft";

      await expect(
        marketplace
          .connect(seller)
          .createToken(tokenURI, 0, { value: ListingPrice })
      ).to.be.revertedWith("Price must be at least 1 wei");
    });
  });

  describe("Marketplace Sales", function () {
    it("Should allow a buyer to purchase a listed NFT", async function () {
      const { marketplace, ListingPrice, seller, buyer } = await loadFixture(
        deployMarketplaceFixture
      );

      const tokenURI = "https://example.com/nft";
      const price = ethers.utils.parseUnits("1", 18);

      await marketplace
        .connect(seller)
        .createToken(tokenURI, price, { value: ListingPrice });

      await marketplace.connect(buyer).CreateMarketSale(1, { value: price });

      const marketItem = await marketplace.IdMarketItems(1);
      expect(marketItem.owner).to.equal(buyer.address);
      expect(marketItem.sold).to.equal(true);
    });

    it("Should revert sale if listing price is not met", async function () {
      const { marketplace, ListingPrice, seller, buyer } = await loadFixture(
        deployMarketplaceFixture
      );

      const tokenURI = "https://example.com/nft";
      const price = ethers.utils.parseUnits("1", 18);

      await marketplace
        .connect(seller)
        .createToken(tokenURI, price, { value: ListingPrice });

      await expect(
        marketplace
          .connect(buyer)
          .CreateMarketSale(1, { value: ethers.utils.parseEther("0.5") })
      ).to.be.revertedWith("please submit asking price to call this function");
    });
  });

  describe("Updating Listing Price", function () {
    it("Should allow only the owner to update the listing price", async function () {
      const { marketplace, owner, seller } = await loadFixture(
        deployMarketplaceFixture
      );

      const newPrice = ethers.utils.parseUnits("0.05", 18);

      await marketplace.connect(owner).updateListingPrice(newPrice);
      expect(await marketplace.getListingPrice()).to.equal(newPrice);

      await expect(
        marketplace.connect(seller).updateListingPrice(newPrice)
      ).to.be.revertedWith("Only Owner can call this function");
    });
  });
});

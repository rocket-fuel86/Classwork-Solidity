// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Shop {
    struct Good {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool isAvailable;
    }

    Good[] private goods;
    uint256 private nextGoodId = 0;

    function addProduct(string calldata name, uint256 price) public {
        goods.push(Good({
            id: nextGoodId,
            name: name,
            price: price,
            owner: payable(msg.sender),
            isAvailable: true
        }));
        
        nextGoodId++;
    }

    function buyGood(uint256 id) public payable {
        Good storage good = goods[id];
        address payable seller = good.owner;

        require(good.isAvailable, "Product is no longer available");
        require(msg.value >= good.price, "Not enough funds sent to buy this product");
        require(msg.sender != good.owner, "Seller cannot buy their own product");

        seller.call{value:good.price}("");

        if (msg.value > good.price) {
            payable(msg.sender).call{value: msg.value - good.price}("");
        }
    }

    function getAllGoods() public view returns (Good[] memory) {
        return goods;
    }
}
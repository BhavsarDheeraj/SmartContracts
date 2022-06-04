// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // ETH to USD
    function getPriceInUSD() internal view returns(uint256) {
        // ABI
        // Address 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        // Since the price has got 8 decimal places and we need to return price with 18 decimal value
        // We will simply multiply it by 1e10 i.e. 10 ** 10 which will make it with 18 decimal value
        return uint256(price * 1e10);
    }

    // Converter method from ETH to USD
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        // Price of 1 ETH is:
        uint256 ethPrice = getPriceInUSD();
        // dividing the result by 10 ** 18 to avoid extra 18 zeros at the end after multiplication
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        // returns 3000_000000000000000000 where 3000 is 1 ETH in USD
        return ethAmountInUSD;
    }
}

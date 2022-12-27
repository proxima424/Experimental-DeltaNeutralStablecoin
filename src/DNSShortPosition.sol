// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {AggregatorV3Interface} from "../src/AggregatorV3Interface.sol";


contract DNSShortPosition {

    /*           ERRORS             */
    error INVALID_USER(address entrant);

    constructor(){
        priceFeed =
            AggregatorV3Interface(0x48731cF7e84dc94C5f84577882c14Be11a5B7456);
    }

    /// @notice Address of the controlling factory contract
    address immutable factory;

    ///@notice Contains relevant data related to a position
    struct CollateralData {
        address token;
        uint256 amount;
        uint256 tokenId;
        uint256 startPrice;
    }

    function getCurrentShortPosition(CollateralData memory params) external returns(uint256 magnitudePNL,uint256 indicator){
        // returns ( magnitude of PNL , ( 0 for negative,1 for positive ) )
        uint256 currentPrice = getLatestPrice(); // 6 Decimals
        uint256 magnitudePNL = currentPrice > params.startPrice ? currentPrice - params.startPrice : params.startPrice - currentPrice ;
        uint256 indicator = currentPrice > params.startPrice ? 0 : 1 ;
        uint256 magnitudePNL = magnitudePNL * params.amount ; // need to divide this py 10**24
    }

    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        // for LINK / USD price
        return price;
    }




    /// @notice Instead of a modifier, we include this line at the start of every function
    /// @notice This is to decrease contract bytecode size (find out more why)
    function onlyFactory() internal {
        if(msg.sender != factory){
            revert INVALID_USER(msg.sender);
        }
        _;
    }


}

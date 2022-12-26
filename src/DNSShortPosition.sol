// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


contract DNSShortPosition {

    /*           ERRORS             */
    error INVALID_USER(address entrant);

    /// @notice Address of the controlling factory contract
    address immutable factory;

    ///@notice Contains relevant data related to a position
    struct CollateralData {
        address token;
        uint256 amount;
        uint256 tokenId;
        uint256 startPrice;
    }



    constructor(address _factory){
        factory = _factory;
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

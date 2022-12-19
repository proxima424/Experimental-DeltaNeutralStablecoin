// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


contract DNSShortPosition{

    address immutable factory;

    constructor(address _factory){
        factory = _factory;
    }

    function onlyFactory() internal {
        require(msg.sender==factory,"INVALID_USER");
        _;
    }

    struct Collateral
}

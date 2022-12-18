// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15


//dependencies
import {DNSerc721} from "./DNSerc721.sol";

import {Ownable} from
    "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

// interfaces
import {IERC20} from
    "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC721} from
    "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

interface DNSfactory is Ownable, DNSerc721 {
    /////////////////////////// STORAGE ///////////////////////////////////
    address immutable DNSerc20;


    mapping(uint256 => CollateralData) tokenIDToPosition;
    mapping(address => uint256) DNSbalance;

    struct CollateralData {
        address _erc20; //160 bits
        uint96 _amount; // 96 bits
    }

    constructor(string memory name_, string memory symbol_, address _DNSerc20)
        DNSerc721(name_, symbol_)
    {
        DNSerc20 = _DNSerc20;
    }

    ///// USER FLOW //////////////
    //// User deposits collateral ////
    //// Converts data of this collateral into a position ////
    //// Mints an ERC721 Specifying this position ////
    //// Another function called claimDNS which takes into account this

    

    function mintERC20DNS(){}
    function burnERC20DNS(){}
    function mintERC721DNS(){}
    function calculateDNS(){}





}

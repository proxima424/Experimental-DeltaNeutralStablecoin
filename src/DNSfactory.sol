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

    mapping(address => uint256) DNSbalance;

    // address => nonceCount
    mapping(address => uint256) addressNonce;
    // tokenId => CollateralData
    mapping(uint256 => CollateralData) tokenIDToPosition;
    // tokenId => address
    mapping(uint256 => address) checkTokenIdOwner;
    // tokenId => isMinted
    mapping(uint256 => bool) isMinted;

    struct CollateralData {
        address token;
        uint256 amount;
        uint256 tokenId;
    }

    constructor(string memory name_, string memory symbol_, address _DNSerc20)
        DNSerc721(name_, symbol_)
    {
        DNSerc20 = _DNSerc20;
    }

    // Frontend first prompts user to call approve()

    function constructTokenId(
        address _user,
        address _collateral,
        uint256 _amount
    )
        internal
        returns (uint256)
    {
        return uint256(
            keccak256(
                abi.encodePacked(
                    abi.encode(_user), abi.encode(_collateral), _amount, nonceData[_user]
                )
            )
        );
    }

    function createPosition(address _collateral, uint256 _amount)
        external
        returns (CollateralData memory)
    {
        require(_collateral != address(0), "ZERO_ADDRESS");
        require(_amount != 0, "ZERO_AMOUNT");

        IERC20(_collateral).transferFrom(msg.sender, address(this), _amount);

        uint256 currentTokenId =
            constructTokenId(msg.sender, _collateral, _amount);
        CollateralData memory positionData =
        new CollateralData({ token:_collateral,amount:_amount, tokenId : currentTokenId});
        //create function called updateMappings
        tokenIDToPosition[currentTokenId] = positionData;
        nonceData[msg.sender]++;
        checkTokenIdOwner[currentTokenId] = msg.sender;
        isMinted[currentTokenId] = false;

        return positionData;
    }

    function mint
}
///// USER FLOW //////////////
//// User deposits collateral ////
//// Converts data of this collateral into a position ////
//// Mints an ERC721 Specifying this position ////
//// Another function called claimDNS which takes into account this

// function mintERC20DNS(){}
// function burnERC20DNS(){}
// function mintERC721DNS(){}
// function calculateDNS(){}

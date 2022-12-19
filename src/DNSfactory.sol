// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

//dependencies
import {DNSerc20} from "./DNSerc20.sol";

import {DNSerc721} from "./DNSerc721.sol";

import {Ownable} from
    "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

// // interfaces
import {IERC20} from
    "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {IERC721} from
    "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

interface DNSfactory is Ownable, DNSerc721 {
    /////////////////////////// STORAGE ///////////////////////////////////
    address immutable DNSerc20_Address;

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
    {}

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

    // Frontend first prompts user to call approve()
    function createPosition(address _collateral, uint256 _amount)
        external
        returns (CollateralData memory)
    {
        require(_collateral != address(0), "ZERO_ADDRESS");
        require(_amount != 0, "ZERO_AMOUNT");

        bool success =
            IERC20(_collateral).transferFrom(msg.sender, address(this), _amount);
        require(success, "TRANSFER_FAILED");
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

    function mintERC721Position(uint256 _tokenId) public external {
        require(checkTokenIdOwner[_tokenId] == msg.sender, "INVALID_OWNER");
        require(!isMinted[_tokenId], "INVALID_MINT");
        isMinted[_tokenId] = true;
        _mint(msg.sender, tokenId);
    }

    function updateMappingOnTransfer(
        uint256 _tokenId,
        address _oldOwner,
        address _newOwner
    )
        internal
    {
        checkTokenIdOwner[_tokenId] = _newOwner;
    }

    // Override _transfer and include updateMapping function
    function _transfer(address from, address to, uint256 tokenId)
        internal
        virtual
        override
    {
        require(
            ERC721.ownerOf(tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(
            ERC721.ownerOf(tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];

        unchecked {
            // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
            // `from`'s balance is the number of token held, which is at least one before the current
            // transfer.
            // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
            // all 2**256 token ids to be minted, which in practice is impossible.
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        updateMappingOnTransfer(tokenId, from, to);

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }

    //Tasks left
    // mint ERC20 DNS stablecoin and create a short position on a DEX

    function deployDNSerc20() external onlyOwner {
        DNSerc20 DNStoken = new DNSerc20("DNS","DNS",address(this));
        DNSerc20_Address = address(DNStoken);
    }

    function getAmountDNSToMint(address _erc20,uint256 _quantity) internal returns(uint256 quantity){


    }

    function mintERC20DNS( uint256 theTokenId  ) external returns(bool){
        require(!isMinted[theTokenId],"ALREADY_MINTED");
        CollateralData memory userPosition = tokenIDToPosition[theTokenId];
        uint256 DNS_TO_MINT = getAmountDNSToMint(userPosition.token,userPosition.amount);
        isMinted[theTokenId] = true;
        IERC20(DNSerc20_Address).mint(msg.sender,DNS_TO_MINT);
        // create short position
    }
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

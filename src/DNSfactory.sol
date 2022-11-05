pragma solidity ^0.8.15


interface IDNSfactory{
    constructor(){}
    
    /////////////////////////// STORAGE ///////////////////////////////////

    address immutable DNSerc721;
    address immutable DNSerc20;

    struct CollateralData{
        address _erc20;  //160 bits
        uint96 _amount;  // 96 bits 
    }
    mapping(uint256=>CollateralData) tokenIDToPosition; 
    mapping(address=>uint256) DNSbalance;
    

    function deployERC721(){
        // to be called only once 
        // Deploys the parent ERC721 contract
    }
    
    function depositCollateral(){
        // Transfers ERC20(address) to address(this)
        // Updates mapping,structs 
        // Mints ERC721 with tokenId specifying this position
    }

    function mintERC721(){
        // To be called by depositCollateral
        // Constructs tokenID from input parameters
        // Calls DNSerc721 and mints the SVG NFT
    }

    function mintDNS(){
        // Checks whether caller is owner of the given tokenID
        // Reconstructs params from PositionData struct
        // Takes short position of the given asset 
        // Calls ChainlinkFunction which returns amount of DNS to be minted
        // Calls DNSerc20 and mints $DNS 
    }

    function getPricefromChainlink(){
        // Calls AggregatorV3Interface to fetch value of the asset in USD
        // Returns uint256 DNS Amount
    }

    function takeShortPosition(){
        //
    }

    function burnDNS(){
        // Calls DNSerc20 and burns $DNS
    }


    
    


    
    



}
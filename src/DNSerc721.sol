// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

//dependencies
import {ERC721} from
    "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract DNSerc721 is ERC721 {
    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    function mint(address _to, uint256 _tokenId) internal returns (bool) {
        _mint(_to, _tokenId);
    }
}

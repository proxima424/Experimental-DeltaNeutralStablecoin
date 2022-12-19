// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

//dependencies
import {ERC20} from
    "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DNSerc20 is ERC20 {
    address immutable DNSfactory;

    constructor(string memory _name, string memory _symbol, address _DNSfactory)
        ERC20(_name, _symbol)
    {
        DNSfactory = _DNSfactory;
    }

    function onlyFactory() internal {
        require(msg.sender == DNSfactory, "INVALID_CALLER");
        _;
    }

    function mint(address _receiver, uint256 quantity) external {
        onlyFactory();
        _mint(_receiver, quantity);
    }

    function burn(address _receiver, uint256 quantity) external {
        onlyFactory();
        _burn(_receiver, _quantity);
    }
}

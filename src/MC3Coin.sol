// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// For more information on the underlying token standard:
// https://eips.ethereum.org/EIPS/eip-20

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/v0.8/interfaces/AggregatorV3Interface.sol";

contract MC3Coin is ERC20 {
    constructor() ERC20("MC3 Coin", "MC3") {
        // Here we define total supply
        _mint(msg.sender, (10 ** uint256(decimals())));
        token_admin[msg.sender] = true;
    }

    // Defines administrative permissions for token -
    // specifically, who is allowed to mint new tokens.
    mapping(address => bool) public token_admin;

    function addAdmin(address _adminAddress) public onlyAdmin {
        require(token_admin[_adminAddress] != true, "Address already admin.");
        token_admin[_adminAddress] = true;
    }

    function removeAdmin(address _adminAddress) public onlyAdmin {
        delete token_admin[_adminAddress];
    }

    // Function to check if the sender is an authorized owner
    modifier onlyAdmin() {
        require(token_admin[msg.sender]);
        _;
    }

    function mint(uint256 _amount) public payable onlyAdmin {
        _mint(msg.sender, _amount);
    }
}

contract MC3Treasury {
    IERC20 token;
    AggregatorV3Interface internal ethDataFeed;
    uint256 public tokenPriceUsd = 1e6;
    bool public isLatest = true;
    address[] public token_holders;
    
    // Mapping of owner addresses and their permissions (in this case, just one permission)
    mapping(address => bool) public admin;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
        addAdmin(msg.sender);

        // Chainlink mainnet data feed for ETH/USD price.
        // ethDataFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

        // Chainlink sepolia testnet data feed for ETH/USD price.
        ethDataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function addAdmin(address _adminAddress) public {
        require(admin[_adminAddress] != true);
        admin[_adminAddress] = true;
    }

    function removeAdmin(address _adminAddress) public onlyAdmin {
        delete admin[_adminAddress];
    }

    // Function to check if the sender is an authorized owner
    modifier onlyAdmin() {
        require(admin[msg.sender]);
        _;
    }

    function getEthPrice() public view returns (uint256) {
        // Returns current ethereum price in USD.
        (
            /* uint80 roundId */
            ,
            int256 answer,
            /*uint256 startedAt*/
            ,
            /*uint256 updatedAt*/
            ,
            /*uint80 answeredInRound*/
        ) = ethDataFeed.latestRoundData();

        uint8 decimals = ethDataFeed.decimals();
        uint256 conversion_factor = 10 ** decimals;
        return uint256(answer) / conversion_factor;
    }

    function withdrawToken(uint256 _amount) external onlyAdmin {
        // Allow authorized owners to withdraw tokens.
        token.transfer(msg.sender, _amount);
    }

    function withdrawEth(uint256 _amount) external payable onlyAdmin {
        // Allows admin to withdraw any ETH that has been deposited.
        require(address(this).balance > _amount, "Insufficient funds!");
        payable(msg.sender).transfer(_amount);
    }

    function sendToken(address _to, uint256 _amount) external onlyAdmin {
        token.transfer(_to, _amount);
    }

    function getTreasuryBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function getBalance(address address_) external view returns (uint256) {
        // Returns the balance of the contract in ETH.
        return token.balanceOf(address_);
    }

    function setTokenPrice(uint256 _price) external onlyAdmin {
        // This function can be used to set the price of the token.
        // Currently, we are not implementing this as a state variable.
        // Instead, we use the Chainlink data feed to get the ETH price.
        // This is a placeholder for future functionality.
    }


    function EthToTokenConversionFactor() external view returns (uint256) {
        // We can implement an arbitrary function here specifying
        // how donations should convert to MC3 tokens.
        // Currently specified as eth -> token conversion.

        // Note, we can't work with decimals, so specifying things in units
        // of some larger quantity is a work-around.
        uint256 tokensPerThousandDollars = 100;

        uint256 priceInDollars = this.getEthPrice();

        return (priceInDollars * (tokensPerThousandDollars)) / 1000;
    }

    function buyToken() public payable returns (bool) {
        // A mechanism to directly purchase tokens with eth.
        // uint256 sent_value_in_eth = SafeMath.div(msg.value, 1 ether, "Conversion error.");
        uint256 sent_value_in_eth = msg.value / 1 ether;
        uint256 num_tokens = sent_value_in_eth * this.EthToTokenConversionFactor();
        token.transfer(msg.sender, num_tokens);
        return true;
    }

    function recieve() external payable {
        // If no specific function is called, we assume this is a buyToken call.
        this.buyToken();

    }


}

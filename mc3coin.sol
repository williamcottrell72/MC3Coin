// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// For more information on the underlying token standard:
// https://eips.ethereum.org/EIPS/eip-20


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract MC3Coin is ERC20 {

    constructor() ERC20("MC3 Coin", "MC3") {
        // Here we define total supply 
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
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


    // Mapping of owner addresses and their permissions (in this case, just one permission)
    mapping(address => bool) public admin;
    
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


    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
        addAdmin(msg.sender);
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

    function getBalance() external view returns(uint256){
        return token.balanceOf(address(this));
    } 

    function EthToTokenConversionFactor() external pure returns(uint256){
        // We can implement an arbitrary function here specifying
        // how donations should convert to MC3 tokens.
        // Currently specified as eth -> token conversion but could 
        // switch to dollar units with oracle.  
        return 1;
    }

    function buyToken() public payable returns(bool) {
        // A mechanism to directly purchase tokens with eth. 
        uint256 token_value = SafeMath.div(msg.value,  1 ether , "Conversion error." ) * this.EthToTokenConversionFactor();
        token.transfer(msg.sender, token_value);
        return true;
    }

}

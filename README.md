# MC3Coin

A fundraising [ERC20](https://eips.ethereum.org/EIPS/eip-20) token for MC3.  Doners can purchase MC3 tokens which will be exchangeable in the future for entry tickets and other perks at  [MC3](https://www.mathculturalcenter.org/the-project).  

### Notes

1. This has been implemented as a simple ERC20 token plus a "treasury".  The treasury contract will hold the token and implement any logic for dispersement.  This allows for greater flexibility - we can update the treasury contract without changing the underlying token.
2. We have created special permissions for "admin" and given those with admin privileges the power to arbitrarily mint and move tokens.  This is not really aligned with the general web3 ethos but I think that for a small specialized project like this we can be forgiven.

### TODOs

1. Implement a useful [bonding curve](https://www.coinbase.com/learn/advanced-trading/what-is-a-bonding-curve).
2. Currently we only allow token purchanes in units of ETH - should we also allow exchanges for stable coins?
3. Refine admin privileges.


## Deployments

### <ins>Sepolia Testnet</ins>


##### MC3 ERC20 Token: 
[2025-07-13](https://sepolia.etherscan.io/address/0xECA785CE55d880357b02295e2e5eC413c20Aa2AA)
[2025-07-27](https://sepolia.etherscan.io/address/0x24dbba52fc9815e55e13d1d688f6861c03f45dac)


##### Treasury Contract: 

[2025-07-13](https://sepolia.etherscan.io/address/0x05f2d7730e8cb54614c1ecbbb340cbc8a3247552)
[2025-07-15](https://sepolia.etherscan.io/address/0xf62AbA2F4999cCc4453e28C1318F4E4B5aFE4000)
[2025-08-16](https://sepolia.etherscan.io/address/0x2051b68F05Ef05EB152e0C193ddDa745cb36F564)

Latest release commit [here](https://github.com/williamcottrell72/MC3Coin/commit/67c8a9a2bdd78367ad0ddb3dcfabe347c6aa9980).
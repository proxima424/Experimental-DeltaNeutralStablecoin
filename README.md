
## Delta Neutral Stablecoin? WTF?

`Delta Neutral Stablecoin` is one of the very few elegant stablecoin design mechanisms in the crypto space right now. </br>
What the `Delta Neutral` stands for is the hedged risk the stablecoin offers via creating a derivative position.</br>
The `UXD Stablecoin` is one of the best examples of a `DNS` implemented on top of `Mango Market`</br>
In this repo, I try to simulate a Delta-Neutral-Stablecoin

Here's how it works : </br>

1) User deposits `amount X` of an `asset Y` with the current price being `Z USD`. </br>
2) The protocol goes ahead and mints `X*Z` amount of `DNS` to the user corresponding to the deposited amount. </br>
3) The protocol goes ahead and creates a short position of the same asset in a Derivative DEX to `hedge the volatility risk` </br>

You see the Delta Neutral Nature yet Anon? </br>

If  price of the asset Y changes by `\Delta$ a`, the `ProfitNLoss` on his deposited amount grows to X*(Z + \Delta$ a * Z )
The PNL on the short position opened up amounts to -X*(ZY/100)
You add that up, you get 0


## Contracts

```ml

├─ DNSfactory.sol — Contract containing all core functions like minting DNS, burning DNS, etc.
├─ DNSerc20.sol   — Parent ERC20 contract of DNS stablecoin
├─ DNSerc721.sol  — Parent ERC721 contract minting positions/collateral locked by user
├─ DNScollateral.sol — Library containing relevant read-only storage pointers for DNSfactory
├─ DNSprice.sol —  Contract for interacting with Chainlink oracle

```

## Structure

![Raw Architechture](Plan.png)

## Tasks left
- [ ] Separate price getters function to DNSprice.sol
- [ ] Complete opening short position function
- [ ] Try to make the code as readable as possible
- [ ] Foundry tests bhai, foundry tests



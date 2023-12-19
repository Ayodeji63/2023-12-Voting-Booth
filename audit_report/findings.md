### [H-1] Incorrect Reward Distribution to 'For' Voters Locks Remaining Funds in the Contract

**Description:** Within the `VotingBooth::_distributeRewards` function, the calculation for total rewards fails to accurately distribute rewards among 'for' voters. The current approach involves deriving `rewardPerVoter` by dividing the `totalRewards` by the `totalVotes`, inadvertently considering votes against the proposal. Moreover, the calculation for the final voter to prevent to leaving dust funds results in an incomplete distribution, which actually leaves dust.

```javascript
uint256 rewardPerVoter = totalRewards / totalVotes;
```

**Impact:** Misallocation of funds occurs, preventing correct allocation to 'for' voters. Consequently, the contract retains leftover funds indefinitely, rendering it a one-time use contract.

**Proof of Concept:** (Proof Of Code)
Follow the steps below:

1. Import `StdInvariant` from `forge-std/StdInvariant.sol` into `VotingBoothTest.t.sol` contract for invariant testing.

```javascript
import { StdInvariant } from 'forge-std/StdInvariant.sol'
```

2. Add the `StdInvariant` to the inheritance. Ensure that `StdInvariant` is the first in the inheritance chain to avoid `Linearization of inheritance graph impossible` error.

```javascript
contract VotingBoothTest is StdInvariant, Test {}
```

3. Introduce the following invariant test in the contract.

<details>
<summary>Code</summary>

```javascript
  function invariant_booth_balance_must_be_correct() public view {
        if (booth.isActive()) {
            assert(address(booth).balance == ETH_REWARD);
        } else {
            console.log("Voting Booth Balance: ", address(booth).balance);
            assert(address(booth).balance == 0);
        }
    }

```

</details>

4. The assertion will fail, demonstrating incomplete fund distribution to voters.

**Recommeded Mitigation:**

This are the recommended mitigation

1. Revise the denominator of `rewardPerVoter` to `totalVotesFor`:

```javascript
uint256 rewardPerVoter = totalRewards / totalVotesFor;
```

2. Adjust the last voter's reward to avoid leftover funds:

```javascript
if (i == totalVotesFor - 1) {
  rewardPerVoter = address(this).balance
}
```

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {VotingBooth} from "../../../src/VotingBooth.sol";

contract InvariantTest is StdInvariant, Test {
    VotingBooth booth;
    uint256 constant ETH_REWARD = 10e18;
    address[] voters;
    uint256 runTime;

    function setUp() external {
        deal(address(this), ETH_REWARD);
        voters.push(address(0x1));
        voters.push(address(0x2));
        voters.push(address(0x3));
        voters.push(address(0x4));
        voters.push(address(0x5));
        voters.push(address(0x6));
        voters.push(address(0x7));
        voters.push(address(0x8));
        voters.push(address(0x9));
        booth = new VotingBooth{value:ETH_REWARD}(voters);

        // allowed voters

        // *snip: add address to `voters`, create contract to be tested *//

        // constrain fuzz test senders to the set of allowed voting addresses
        for (uint256 i; i < voters.length; ++i) {
            targetSender(voters[i]);
        }

        targetContract(address(booth));
    }

    receive() external payable {}

    function invariant_isActive_should_be_false() public {
        runTime++;
        if (runTime >= 5) {
            assert(booth.isActive() == true);
            assert(address(booth).balance > 0);
        }
        console.log("Run Time", runTime);
    }

    function invariant_rewards_must_be_distributed() public {
        runTime++;
        if (runTime < 4) {
            assert(address(booth).balance > 0);
            assert(booth.isActive() == true);
        }
    }
}

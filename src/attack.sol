// SPDX-License-Identifier: MIT
import {VotingBooth} from "./VotingBooth.sol";

contract Attacker {
    VotingBooth booth;

    constructor(address _addr) {
        booth = VotingBooth(_addr);
    }

    receive() external payable {
        if (address(booth).balance >= 1) {}
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

contract TimeLock is TimelockController {
    // min delay: time to wait before executing
    // proposals: list of addresses that can propose
    // executors: list of addresses that can execute
    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors
    ) TimelockController(minDelay, proposers, executors, msg.sender) {}
}

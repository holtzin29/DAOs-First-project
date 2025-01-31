// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
import {Test, console} from "forge-std/Test.sol";
import {Box} from "../src/DaoBox.sol";
import {GovToken} from "../src/DaoGovToken.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {MyGovernor} from "../src/myGov.sol";

contract myGovTest is Test {
    MyGovernor governor;
    Box box;
    TimeLock timelock;
    GovToken govToken;

    address public USER = makeAddr("user");
    uint256 public constant INITIAL_SUPPLY = 100 ether; // minted 100 tokens
    uint256 public constant VOTING_DELAY = 1; // how many blocks til a vote is active
    uint256 public constant VOTING_PERIOD = 50400;

    address[] proposers; // anybody can execute and propose
    address[] executors;

    uint256[] values;
    bytes[] calldatas;
    address[] targets;

    uint256 public constant MIN_DELAY = 3600; // 1h

    function setUp() public {
        govToken = new GovToken();
        govToken.mint(USER, INITIAL_SUPPLY);

        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors);
        governor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE(); // only the governor can propose
        bytes32 executorRole = timelock.EXECUTER_ROLE();
        bytes32 adminRole = timelock.TIMELOCK_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor)); // just the governor can propose
        timelock.grantRole(executorRole, address(0)); // anybody can execute
        timelock.revokeRole(adminRole, USER); // the user is no longer the admin
        vm.stopPrank();

        box = new Box();
        box.transferownership(address(timelock)); // time locks own the dao and the dao owns the timelock
    }

    function testCantUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

    function testGovernanceUpdatesBox() public {
        uint256 valueToStore = 88;
        string memory description = "store 1 in Box";
        bytes memory encodedFunctionCall = abi.encodeWithSignature(
            "store(uint256)",
            valueToStore
        );

        values.push(0);
        calldatas.push(encodedFunctionCall);
        targets.push(address(box));

        //propose the dao
        uint256 proposalId = governor.propose(
            targets,
            values,
            calldatas,
            description
        );
        // view the state
        console.log("Proposal State", uint256(governor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        wm.roll(block.number + VOTING_DELAY + 1);

        console.log("Proposal State", uint256(governor.state(proposalId)));

        // voting
        string memory reason = "Because i want to";

        uint8 voteWay = 1; // voting yes
        vm.prank(USER);
        governor.castVoteWithReason(proposalId, voteWay, reason);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        wm.roll(block.number + VOTING_PERIOD + 1);

        // queue the transaction before execute
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1);
        wm.roll(block.number + MIN_DELAY + 1);

        // execute

        governor.execute(targets, values, calldatas, descriptionHash);
        console.log("Box value: ", box.getNumber());
        assert(box.getNumber() == valueToStore);
    }
}

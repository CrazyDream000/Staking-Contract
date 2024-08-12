// stake: Lock tokens into our smart contract (Synthetix version?)
// withdraw: unlock tokens from our smart contract
// claimReward: users get their reward tokens
//      What's a good reward mechanism?
//      What's some good reward math?

// Added functionality ideas: Use users funds to fund liquidity pools to make income from that?

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

error Staking__TransferFailed();
error Withdraw__TransferFailed();
error Staking__NeedsMoreThanZero();

contract Staking is ReentrancyGuard {
    IERC20 public s_stakingToken;
    IERC20 public s_rewardToken;

    uint256 public constant REWARD_RATE = 100;
    uint256 public s_totalSupply;
    uint256 public s_rewardPerTokenStored;
    uint256 public s_lastUpdateTime;

    /** @dev Mapping from address to the amount the user has staked */
    mapping(address => uint256) public s_balances;

    /** @dev Mapping from address to the amount the user has been rewarded */
    mapping(address => uint256) public s_userRewardPerTokenPaid;

    /** @dev Mapping from address to the rewards claimable for user */
    mapping(address => uint256) public s_rewards;

    modifier updateReward(address account) {
        // how much reward per token?
        // get last timestamp
        // between 12 - 1pm , user earned X tokens. Needs to verify time staked to distribute correct amount to each
        // participant
        s_rewardPerTokenStored = rewardPerToken();
        s_lastUpdateTime = block.timestamp;
        s_rewards[account] = earned(account);
        s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;

        _;
    }

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert Staking__NeedsMoreThanZero();
        }
        _;
    }

    constructor(address stakingToken, address rewardToken) {
        s_stakingToken = IERC20(stakingToken);
        s_rewardToken = IERC20(rewardToken);
    }

    function earned(address account) public view returns (uint256) {
        uint256 currentBalance = s_balances[account];
        // how much they were paid already
        uint256 amountPaid = s_userRewardPerTokenPaid[account];
        uint256 currentRewardPerToken = rewardPerToken();
        uint256 pastRewards = s_rewards[account];
 100) => (10), Withdraw 0
        // Person C: 100 staked, Earned: 50, Withdraw 0
        // @ Time = 4
        // Person A Withdraws & claimed rewards on everything!
        // Person A: 0 staked, Withdraw: 280
    }

    // Getter for UI
    function getStaked(address account) public view returns (uint256) {
        return s_balances[account];
    }
}

// SPDX-License-Identifier: UNLINCENSED
pragma solidity 0.8.28;
import './ERC20.sol';

contract PiggyBank {
    address public owner;
    address private developerAddress;
    string public purpose;
    uint8 private durationMonths;
    uint32 private constant monthsInSecs = 30 * 24 * 60 * 60;
    uint8 public constant penaltyFee = 15;
    uint256 private withdrawalDate;
    bool public isWithdrawn;
    address tokenAddress;
    uint256 public balance;

    error notOwner();
    error Withdrawn();

    constructor(address _owner, uint8 _durationMonths, string memory _purpose, address _developerAddress, address _tokenAddress) {
        developerAddress = _developerAddress;
        owner = _owner;
        durationMonths = _durationMonths;
        purpose = _purpose;
        tokenAddress = _tokenAddress;
        withdrawalDate = block.timestamp + (monthsInSecs * durationMonths);
    }

    modifier onlyOwner {
        if(msg.sender != owner)
            revert notOwner();
        _;
    }

    modifier checkWithdraw() {
        if(isWithdrawn) 
        revert Withdrawn();
        _;
    }

    function save(uint256 _amount) external onlyOwner checkWithdraw {
        require(_amount > 0, "You dey whine? Amount can't be less than zero.");
        ERC20 token = ERC20(tokenAddress);
        bool success = token.transferFrom(msg.sender, address(this), _amount);
        require(success, "Aw Snap! You ain't giving me no money");
        balance += _amount; 
    }
    
    function withdraw() external onlyOwner checkWithdraw {
        isWithdrawn = true;
        require(block.timestamp >= withdrawalDate, "You go like chill? Is it urgent?");
        ERC20(tokenAddress).transfer(owner, balance);
        balance = 0;
    }

    function calcPen(uint256 _amount) internal pure returns(uint256) {
        return (_amount * penaltyFee) / 100;
    }

    function emergency() external onlyOwner checkWithdraw {
        isWithdrawn = true;
        require(block.timestamp < withdrawalDate, "You are saying it is urgent, hmm. Ok 15% for me!");
        uint256 penalty = calcPen(balance);
        ERC20(tokenAddress).transfer(developerAddress, penalty);
        ERC20(tokenAddress).transfer(owner, balance - penalty);
        balance = 0;
    }
}
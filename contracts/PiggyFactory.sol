// SPDX-License-Identifier: UNLINCENSED
pragma solidity 0.8.28;
import './PiggyBank.sol';

contract PiggyFactory {

    struct detailsOfPiggyBank {
        address piggyBankAddress;
        string purpose;
    }

    enum Token {
        DAI,
        USDC,
        USDT
    }
    mapping(Token => address) tokenAddress;

    uint256 noOfPiggyBank;
    address developerAddress;
    mapping(address => detailsOfPiggyBank[]) users;

    // error noPiggyForUser();
    // error noActivePiggy();
    error piggyCreationFailed();

    constructor() {
        developerAddress = msg.sender;
        tokenAddress[Token.DAI] = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        tokenAddress[Token.USDC] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        tokenAddress[Token.USDT] = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    }

    function createPiggyBank(uint8 durationMonths, string memory purpose, Token _token) external returns (address piggyBankAddress){

        bytes memory _bytecode = getByteCode(durationMonths, purpose, _token);
        uint256 _newPiggyBank = noOfPiggyBank + 1;

        assembly {
            piggyBankAddress := create2(0, add(_bytecode, 32), mload(_bytecode), _newPiggyBank)
        }

        if(piggyBankAddress == address(0)) revert piggyCreationFailed();
        detailsOfPiggyBank memory _newDetails = detailsOfPiggyBank (
            piggyBankAddress,
            purpose
        );
         noOfPiggyBank = _newPiggyBank;
         users[msg.sender].push(_newDetails);
    }

    function getByteCode(uint8 durationMonths, string memory purpose, Token _token) private view returns (bytes memory){
         bytes memory _bytecode = abi.encodePacked(type(PiggyBank).creationCode, abi.encode(msg.sender, durationMonths, purpose, developerAddress, tokenAddress[_token]));
        return _bytecode;
    }

    
}
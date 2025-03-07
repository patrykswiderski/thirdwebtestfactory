// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@thirdweb-dev/contracts/prebuilts/account/utils/BaseAccountFactory.sol";
import "./UserContract.sol";

contract UserContractFactory is BaseAccountFactory {

    event RegisteredUsername(string username, address account);
    mapping(string => address) public accountOfUsername;
    mapping(address => string) public usernameOfAccount;
    mapping(address => bool) public hasUsername;

    constructor(
        IEntryPoint _entrypoint
    ) 
        BaseAccountFactory(
            address(new UserContract(_entrypoint, address(this))), address(_entrypoint)
        )
    {}

    function _initializeAccount(
        address _account,
        address _admin,
        bytes calldata _data
    ) internal override {
        UserContract(payable(_account)).initialize(_admin, _data);
    }

    function onRegistered(
        string calldata username
    ) external {
        address account = msg.sender;
        require(this.isRegistered(account), "UsernameContractFactory: account not registered");
        require(accountOfUsername[username] == address(0), "UsernameContractFactory: username already registered");
        accountOfUsername[username] = account;
        usernameOfAccount[account] = username;
        hasUsername[account] = true;
        emit RegisteredUsername(username, account);
    }
}
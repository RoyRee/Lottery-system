// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

contract Lottery {
    address payable public  manager;
    // mapping (uint => address) desposithistory;
    address payable[] public players;
    // uint public participants;

    event managerEvent(address _manager, uint _amount);
    event winnerEvent(address _winner,uint _amount);

    constructor(address _manager){
        manager = payable(_manager);
    }

    modifier checkManager() {
        require(msg.sender == manager,"Invalid Manager");
        _;
    }

    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function deposit() public payable {
        require(msg.sender != manager,"Manager can't Participate");
        require(msg.value ==  1 ether,"Invalid amount");
        // desposithistory[participants] = msg.sender;
        players.push(payable(msg.sender));
    }

    function selectWinner() public payable checkManager {
        uint _balance = address(this).balance;
        require(players.length >= 2 , "Not engough Participants");
        uint i = random() % players.length;
        // console.log(i);
        uint manager_part = (_balance * 5) / 100;
        uint reward = _balance - manager_part;
        manager.transfer(manager_part);
        emit managerEvent(manager,manager_part);
        payable(players[i]).transfer(reward);
        emit winnerEvent(players[i],reward);
        resetLottery(); 
    }

     function resetLottery() internal {
        players = new address payable[](0);
    }
}
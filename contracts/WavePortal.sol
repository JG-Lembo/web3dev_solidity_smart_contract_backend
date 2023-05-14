// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {

    struct Message {
        address writer;
        string message;
    }

    uint256 totalReads;
    uint256 todayReads;
    uint256 lastDay;
    uint256 currentMessageIndex;
    Message[] messages;

    event NewMessageReceived(address writer, string message);
    event MessageGenerated(Message message);

    mapping(address => uint256) public lastSuggestionAt;

    constructor () payable{
        console.log("Meu primeiro contrato inteligente! - Ass: JG10");
        lastDay = block.timestamp; 
        currentMessageIndex = 0;
        address deployer = msg.sender;
        messages.push(Message(deployer, "Com grandes poderes, vem grandes responsabilidades"));
        messages.push(Message(deployer, "Faca ou nao faca; tentativa nao ha"));
        messages.push(Message(deployer, "Quando voce elimina o impossivel, o que restar, nao importa o quao improvavel, deve ser a verdade."));
    }

    function receiveMessageOfTheDay(string memory message) public {

        require(
            lastSuggestionAt[msg.sender] / 86400 != block.timestamp / 86400,
            "Voce so pode fazer uma sugestao por dia."
        );

        lastSuggestionAt[msg.sender] = block.timestamp;

        totalReads += 1;
        console.log("%s pediu a frase do dia!", msg.sender);
        if (block.timestamp / 86400 != lastDay / 86400) {
            lastDay = block.timestamp;
            todayReads = 0;
            if (currentMessageIndex == messages.length - 1) {
                currentMessageIndex = 0;
            } else {
                currentMessageIndex += 1;
            }
        }
        todayReads += 1;
        emit MessageGenerated(messages[currentMessageIndex]);

        messages.push(Message(msg.sender, message));
        emit NewMessageReceived(msg.sender, message);

        if (totalReads % 100 == 0) {
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Tentando sacar mais dinheiro que o contrato possui."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Falhou em sacar dinheiro do contrato.");
        }
    }

    function checkUserSentMessage() public view returns (bool) {
        if (lastSuggestionAt[msg.sender] / 86400 == block.timestamp / 86400)
            return true;
        return false;
    }

    function getMessageOfTheDay() public view returns (Message memory) {

        require (checkUserSentMessage(),
        "Voce ainda nao mandou sua sugestao hoje");

        return messages[currentMessageIndex];
    }

    function getReads() public view returns (uint256, uint256) {
        console.log("%d pessoas ja pediram as frases do dia!", totalReads);
        console.log("%d pessoas pediram a frase de hoje!", todayReads);
        return (totalReads, todayReads);
    }
}
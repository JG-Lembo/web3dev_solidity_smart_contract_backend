const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
      value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();

    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);

    let contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      "Saldo do contrato:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    let waveCount;
    waveCount = await waveContract.getReads();
    console.log(waveCount);

    let message = await waveContract.receiveMessageOfTheDay("Nova frase");
    message = await message.wait();
    console.log(message.events[0].args[0]);

    waveCount = await waveContract.getReads();
    console.log(waveCount);

    message = await waveContract.connect(randomPerson).receiveMessageOfTheDay("Mais uma frase");
    message = await message.wait();
    console.log(message.events[0].args[0]);

    for (let i = 0; i < 97; i++) {
      message = await waveContract.connect(randomPerson).receiveMessageOfTheDay("Mais uma frase");
      message = await message.wait();
    }

    waveCount = await waveContract.getReads();
    console.log(waveCount);

    message = await waveContract.connect(randomPerson).receiveMessageOfTheDay("Mais uma frase");
    message = await message.wait();
    console.log(message.events[0].args[0]);

    waveCount = await waveContract.getReads();
    console.log(waveCount);

    contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      "Saldo do contrato:",
      hre.ethers.utils.formatEther(contractBalance)
    );
};
  
const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
};
  
runMain();
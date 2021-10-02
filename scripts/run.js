const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT')
  const nftContract = await nftContractFactory.deploy()
  await nftContract.deployed()
  console.log(`Contract deployed to: ${nftContract.address}, yay!`)

  let txn = await nftContract.makeAnEpicNFT()
  await txn.wait()

  txn = await nftContract.makeAnEpicNFT()
  await txn.wait()
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (e) {
    console.log(e)
    process.exit(1)
  }
}

runMain()
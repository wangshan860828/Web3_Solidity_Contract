const { ethers } = require("hardhat");
const { getNamedAccounts, deployments } = require("hardhat");

async function main() {
  const MyToken = await ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy("MyToken", "MTK");
  await myToken.waitForDeployment();
  console.log("MyToken deployed to:", myToken.target);

  const { firstAccount, secondAccount } = await getNamedAccounts();
  console.log("firstAccount:", firstAccount);
  console.log("secondAccount:", secondAccount);

  const firstAccountBalance = await myToken.balanceOf(firstAccount);
  console.log("firstAccountBalance:", firstAccountBalance);
  const secondAccountBalance = await myToken.balanceOf(secondAccount);
  console.log("secondAccountBalance:", secondAccountBalance);

  await myToken.safeMint(firstAccount);
  await myToken.safeMint(secondAccount);

  const firstAccountBalanceAfter = await myToken.balanceOf(firstAccount);
  console.log("firstAccountBalanceAfter:", firstAccountBalanceAfter);
  const secondAccountBalanceAfter = await myToken.balanceOf(secondAccount);
  console.log("secondAccountBalanceAfter:", secondAccountBalanceAfter);

  const owner = await myToken.ownerOf(0);
  console.log("owner:", owner);
  const owner2 = await myToken.ownerOf(1);
  console.log("owner2:", owner2);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error.message);
    process.exit(1);
  });
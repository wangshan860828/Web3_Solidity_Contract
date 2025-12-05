//具体写法参考【官方网址：https://www.npmjs.com/package/hardhat-deploy】
//deploy/plugin-deploy-fundMe.js

module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();
  await deploy('FundMe', {
    from: deployer,
    args: [3000],
    log: true,
  });
};
module.exports.tags = ['MyContract', 'fundMe'];
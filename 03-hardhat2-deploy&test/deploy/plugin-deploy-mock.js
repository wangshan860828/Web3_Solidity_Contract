// 部署 MockV3Aggregator 合约
module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();
  await deploy('MockV3Aggregator', {
    from: deployer,
    args: ['Hello'],
    log: true,
  });
};
module.exports.tags = ['MyContract', 'mockV3Aggregator'];
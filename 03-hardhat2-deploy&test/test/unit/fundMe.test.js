//写 fundme 的单元测试,用 mocha 和 chai，采用 hardhat-deploy 插件来部署
const { assert, expect } = require("chai")

describe('first', function () {
    it('should return true', async function () {
        //断言 true 为真
        assert.equal(true, true);
    });
});
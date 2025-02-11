    const crypto = require('crypto');

    function mineBlock(difficulty) {
        const nickname = "Now";
        const startTime = Date.now();
        let count = 0;
        while (true) {
            const nonce = crypto.randomBytes(8).toString('hex');
            const data = nickname + nonce;
            const hash = crypto.createHash('sha256').update(data).digest('hex');
            
            // 检查哈希值是否满足难度要求（前n位为0）
            const check = '0'.repeat(difficulty);
            if (hash.startsWith(check)) {
                const endTime = Date.now();
                const timeSpent = (endTime - startTime) / 1000; // 转换为秒
                
                console.log(`\n找到满足${difficulty}个0的哈希值：`);
                console.log(`输入内容: ${data}`);
                console.log(`哈希值: ${hash}`);
                console.log(`耗时: ${timeSpent}秒`);
                console.log(`尝试次数: ${count}`);
                break;
            }
            count++;
        }
    }

    // 先计算4个0
    console.log("开始计算4个0的哈希...");
    mineBlock(4);

    // 再计算5个0
    console.log("\n开始计算5个0的哈希...");
    mineBlock(5);

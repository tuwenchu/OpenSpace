// 引入 crypto 模块，用于计算 SHA256 哈希值
const crypto = require('crypto')

// 定义昵称和要满足的前导零位数
const nickname = 'tuWenchu'
const targetZeroes1 = 4
const targetZeroes2 = 5

// 计算 SHA256 哈希值的函数，并更新输入字符串的哈希值
function computeHash (input) {
  return crypto.createHash('sha256') // 创建 SHA256 哈希对象
    .update(input) // 更新输入数据
    .digest('hex') // 以十六进制编码返回哈希值
}

// 检查哈希值是否满足指定的前导零位数
function isValidHash (hash, zeroes) {
  const requiredPrefix = '0'.repeat(zeroes) // 生成要求的前导零位数字符串
  return hash.startsWith(requiredPrefix) // 检查哈希值是否以该字符串开头
}

// POW 攻击函数，不断计算哈希值直到满足前导零位数条件
function powAttack (zeroes) {
  let nonce = 0 // 初始化 nonce 值为 0
  let hash = '' // 初始化哈希值为空字符串

  console.log(`Starting POW attack for ${zeroes} zeroes...`) // 输出攻击开始信息

  const startTime = Date.now() // 记录攻击开始时间

  // 循环直到找到满足条件的哈希值
  while (!isValidHash(hash, zeroes)) {
    nonce++ // 递增 nonce 值
    hash = computeHash(nickname + nonce.toString()) // 计算哈希值
  }

  const endTime = Date.now() // 记录攻击结束时间
  const elapsedTime = (endTime - startTime) / 1000 // 计算消耗时间（秒）

  // 输出找到的满足条件的哈希值和消耗时间
  console.log(`Found valid hash after，nonce： ${nonce} tries: ${hash}`)
  console.log(`Elapsed time: ${elapsedTime} seconds`)
}

// 运行第一次 POW 攻击，满足 4 个前导零位数的条件
powAttack(targetZeroes1)

// 运行第二次 POW 攻击，满足 5 个前导零位数的条件
powAttack(targetZeroes2)

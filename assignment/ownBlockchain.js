
const crypto = require('crypto')
// 计算哈希值的函数
function calculateHash (timestamp, data, previousHash, nonce) {
  const hashString = timestamp + data + previousHash + nonce
  const hash = crypto.createHash('sha256').update(hashString).digest('hex')
  return hash
}
// 1.计算哈希值(哈希值前4位为0)，包含每一个模块的时间戳、数据、前一个模块的哈希值、次数
// 2.创始块，包含（index、时间戳、data、前一个模块的哈希值、次数、以及自己的哈希值 ）
// 3.
// 创始区块
function createGenesisBlock () {
  return {
    index: 0,
    timestamp: Date.now(),
    data: "Genesis Block",
    previousHash: "0",
    nonce: 0,
    hash: calculateHash(Date.now(), "Genesis Block", "0", 0)
  }
}
// 创建创世块并初始化区块链
const blockchain = [createGenesisBlock()]

// 添加新区块到区块链
function addBlock (data) {
  const previousBlock = blockchain[blockchain.length - 1]
  const newBlock = createBlock(data, previousBlock)
  blockchain.push(newBlock)
}
// 创建新区块
function createBlock (data, previousBlock) {
  const timestamp = Date.now()
  let nonce = 0
  let hash = calculateHash(timestamp, data, previousBlock.hash, nonce)
  // POW 证明出块，直到计算出符合条件的哈希值
  while (hash.substring(0, 4) !== "0000") {
    nonce++
    hash = calculateHash(timestamp, data, previousBlock.hash, nonce)
  }
  return {
    index: previousBlock.index + 1,
    timestamp: timestamp,
    data: data,
    previousHash: previousBlock.hash,
    nonce: nonce,
    hash: hash
  }
}
// 测试添加新区块
let count = 1
while (count < 4) {
  addBlock(`${count}"First Block"`)
  count++
}
// 打印区块链数据
console.log(blockchain)

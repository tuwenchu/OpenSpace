const crypto = require('crypto')

// 生成 RSA 密钥对
const { privateKey, publicKey } = crypto.generateKeyPairSync('rsa', {
  modulusLength: 2048, // 模数长度为 2048 bits
  publicKeyEncoding: {
    type: 'pkcs1', // 公钥编码格式为 pkcs1
    format: 'pem'   // 输出格式为 PEM 格式
  },
  privateKeyEncoding: {
    type: 'pkcs1', // 私钥编码格式为 pkcs1
    format: 'pem'   // 输出格式为 PEM 格式
  }
})

// 昵称和要签名的消息
const nickname = 'tuWenchu'

// 使用私钥对消息进行签名
const sign = crypto.createSign('RSA-SHA256') // 创建签名对象
sign.update(nickname) // 更新签名内容为消息
sign.end() // 结束更新
const signature = sign.sign(privateKey, 'hex') // 对消息进行签名
console.log('Signature:', signature)

// 使用公钥验证签名
const verify = crypto.createVerify('RSA-SHA256') // 创建验证对象
verify.update(nickname) // 更新验证内容为消息
verify.end() // 结束更新
const isValidSignature = verify.verify(publicKey, signature, 'hex') // 验证签名
console.log('Signature verified:', isValidSignature) // 输出验证结果

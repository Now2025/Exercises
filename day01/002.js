const crypto = require('crypto');

// Generate RSA key pair
const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
    modulusLength: 2048,
    publicKeyEncoding: {
        type: 'spki',
        format: 'pem'
    },
    privateKeyEncoding: {
        type: 'pkcs8',
        format: 'pem'
    }
});

// Function to find nonce that produces hash with 4 leading zeros
function findNonce(nickname) {
    let nonce = 0;
    while (true) {
        const data = nickname + nonce;
        const hash = crypto.createHash('sha256').update(data).digest('hex');
        if (hash.startsWith('0000')) {
            return { nonce, hash, data };
        }
        nonce++;
    }
}

// Main execution
const nickname = "Now";
const { nonce, hash, data } = findNonce(nickname);
console.log(`Found nonce: ${nonce}`);
console.log(`Hash: ${hash}`);
console.log(`Data: ${data}`);

// Sign the data with private key
const signature = crypto.sign('sha256', Buffer.from(data), privateKey);
console.log('Signature:', signature.toString('base64'));

// Verify the signature with public key
const isVerified = crypto.verify(
    'sha256',
    Buffer.from(data),
    publicKey,
    signature
);

console.log('Signature verified:', isVerified);

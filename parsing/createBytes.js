const ethers = require('ethers');

async function createBytes(args){
    const name = args[0];
    const bytes = ethers.encodeBytes32String(name);
    console.log(bytes);
}

createBytes(process.argv.slice(2));
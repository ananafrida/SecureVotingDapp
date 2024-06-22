pragma Solidity >= 0.8.2 <0.9.0;

contract SimpleContract{
    // block: block is basically a class that takes variables
    block.number;
    block.difficulty;
    block.coinbase();// this is basically a function

    /* another way to comment out in Solidity */

    //message: is also a class
    msg.sender;

    // transaction: is another class which has gas variable
    tx.gas;

    // unlike other languages, functions in Solidity can return multiple outputs
    // so you have to declare what you return like below
    function cals(uint a, uint b)public pure
    returns (uint o_sum, uint o_product){
        o_sum = a + b;
        o_product = a * b;
    }

    //switch statements and go to are not available in solidity langauge

}
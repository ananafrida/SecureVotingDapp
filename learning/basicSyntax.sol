// import Solidity
pragma Solidity >= 0.8.2 < 0.9.0;

//import files and aliases
import "filename";
import * as symbolname from "filename";

// my first contract
contract SimpleContract{
    //contract code

    //state variable
    uint vari;

    //modifier is a conditional
    modifier onlyData(){
        require(
            vari >= 0
        );
        _;
    }

    //function
    function set(uint x)public{
        vari = x;
    }

    // event
    event Sent(address from, address to, uint vari);
}

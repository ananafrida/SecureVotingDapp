// import Solidity
pragma Solidity >= 0.8.2 < 0.9.0;

//import files and aliases
import "filename";
import * as symbolname from "filename";

// my first contract
contract SimpleContract{
    // contract code

    // array type
    string[] names;

    // Struct to define
    struct User {
        string firstName;
        string secName;
        uint age;
    }

    // enums: pretty similar to struct but you are not defining ahead of time what
    // the values will be. So here the buyers and sellers could be the User
    enum userType {buyer, seller}

    //mapping: Below maps all the address to uint in balances
    mapping(address => uint) public balances;

    //Ether, gwei, and wei are the currencies of the system. 
    // And so they are some reserved keywords

    // second, minutes, hours, days, weeks, years are reserved keywords as time units
    boolIsEqual times = (1 hours == 60 minutes)

}

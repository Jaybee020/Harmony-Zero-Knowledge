// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;


contract HelloWorld{
    uint number;//state vairable to store on blockchain

    //function to change state variable
    function storeNumber(uint _number)public{
        number=_number;
    }

    //fucntion to get state variable on blockchain
    function retrieveNumber()public view returns(uint){
        return number;
    }
}
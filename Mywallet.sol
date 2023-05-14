// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
   
   contract MySimpleWallet {
    
    struct custumer{
        uint balance;
        uint numDepot;
    }
    mapping (address=> custumer) balances;
     
     receive () external payable {
        balances[msg.sender].balance += msg.value;
        balances[msg.sender].numDepot += 1;

     }

    function getTotlaBalance () public view returns (uint) {
          return address(this).balance;
    }
    
    function getBalnceCustomer() public view  returns (uint) {
        return balances[msg.sender].balance;
    }

    function withdrawAllwei () public payable  returns(bool) {
        address  owner = payable(msg.sender);
        uint  money = balances[msg.sender].balance;
        balances[msg.sender].balance = 0 ;
        payable(owner).transfer(money);
        balances[msg.sender].numDepot = 0;
        return true;
    }

   }

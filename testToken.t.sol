// SPDX-License-Identifier: PRIVATE
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/FoundryNFTs.sol";

contract FroundryNftsTest is Test {
    FroundryNfts public tokens;
     address adm = address(1);
     address from = address(2);
     address to = address(3);
      address zero = address(0);
       uint256 id;
       uint256 amount = 1000;
       bytes data = ""; 

    function setUp() public {
        tokens = new FroundryNfts();
        }

    function testsafeTransferFrom () public {

        vm.expectRevert();
        tokens.safeTransferFrom(from,to,id,amount,data);
    }

   
}

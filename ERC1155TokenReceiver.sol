// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract ERC1155TokenReceiver {

    mapping(address => uint256) balanceReceive;
    
    function onERC1155Received(address _operator,
     address _from,
      uint256  _id,
       uint256 _value,
        bytes calldata _data) external returns(bytes4) {
           
            return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
        }

   
    function onERC1155BatchReceived(address _operator, 
    address _from,
     uint256[] calldata _ids,
      uint256[] calldata _values,
       bytes calldata _data) external returns(bytes4) {

        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
       }      
}

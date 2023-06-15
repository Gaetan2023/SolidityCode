// SPDX-License-Identifier: PRIVATE
pragma solidity ^0.8.13;
import "./ERC1155TokenReceiver.sol";

contract FroundryNfts {
    address admistrator;
    mapping (address=>mapping(uint256 =>uint256)) balance;
    mapping (address => mapping(address => bool))approve;
    event TransferSingle(address _adm, address _from, address _to, uint256 _id, uint256 _value);
    event TransferBatch(address _adm, address _from, address _to, uint256 []_id, uint256[] _value);
    event ApprovalForAll(address _owner, address _adm, bool _approved);
     event URI(string _value, uint256 indexed _id);

    constructor ()  {
        admistrator = msg.sender;
    }

   modifier onlyBy(){
                
                if (msg.sender == admistrator) {
                        _;
                               }
   }
    
function safeTransferFrom (
    address _from,
    address _to,
     uint256 _id,
      uint256 _value,
      bytes calldata _data) onlyBy external {
    if (_to == address(0))
    { revert("this address is no permit");}
    if (_value > balance[_from][_id])
    {revert("balance is low");}
      
      uint256 length;
     assembly { length := extcodesize(_to)}

     require ( _from != address(0) , "from address cannot be default null address");
     
     bytes4 magicNumber = bytes4( keccak256("onERC1155Received(admistrator,_from,_to,id,_value,bytes)"));
      if (length > 0) {
            try ERC1155TokenReceiver (_to).onERC1155Received(admistrator, _from, _id, _value, _data) returns (bytes4 response ) {
                if (response != magicNumber) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    
     
      balance[_from][_id] = balance [_from][_id] - _value;
      balance[_to][_id] = balance[_to][_id] + _value;
      emit TransferSingle(admistrator,_from,_to,_id,_value);
 }

   function safeBatchTransferFrom (address _from,
 address _to, 
 uint256 [] memory _ids, 
 uint256 [] memory _values, 
 bytes calldata _data) onlyBy external {
    if (_to == address(0))
    { revert("this address is no permit");}
   
     require(_ids.length == _values.length, "ERC1155: ids and amounts length mismatch");
      
      uint256 length;
     assembly { length := extcodesize(_to)}

     require ( _from != address(0) , "from address cannot be default null address");
     
     bytes4 magicNumber = bytes4(keccak256("onERC1155Received(address,address,uint256 [],uint256[],bytes)"));
      if (length > 0) {
            try ERC1155TokenReceiver (_to).onERC1155BatchReceived(admistrator, _from, _ids, _values, _data) returns (bytes4 response ) {
                if (response != magicNumber) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    

      for (uint256 i = 0; i < _ids.length; ++i) {
            uint256 id = _ids[i];
            uint256 amount = _values[i];

            uint256 fromBalance = balance[_from][id];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                balance [_from][id] = fromBalance - amount;
            }
            balance[_to][id] += amount;
        }
     
     emit TransferBatch(admistrator,_from,_to,_ids,_values);



 }


   function balanceOf(address account, uint256 id) public view returns (uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return balance [account][id];
    }

   
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
    
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    
    function setApprovalForAll(address spender, bool approved) public  {
        
         require(admistrator != spender, "ERC1155: setting approval status for self");
        approve[admistrator][spender] = approved;
        emit ApprovalForAll(admistrator, spender, approved);
        
    }


    function isApprovedForAll( address spender) public view  returns (bool) {
        return approve[admistrator][spender];
}
}

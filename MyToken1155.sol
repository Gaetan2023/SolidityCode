// SPDX-License-Identifier: MIT

//without sendind to external conctract
pragma solidity ^0.8.0;


contract MyToken1155 {


       // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     *  Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(
        address operator,
         address  from, 
         address  to, 
         uint256 id,
          uint256 value);


   
    event TransferBatch(
        address  operator,
        address from,
        address  to,
        uint256[] ids,
        uint256[] values
    );


    event ApprovalForAll(
        address  account, 
        address  operator, 
        bool approved);

  
    


   function balanceOf(address account, uint256 id) public view   returns (uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return _balances[id][account];
    }

    
   function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

   
   

   
     function safeTransferFrom( address from,address to, uint256 id,uint256 amount ) external 
      {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = msg.sender;

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        
       _balances[id][from] = fromBalance - amount;
    
        _balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);}
        

     function safeBatchTransferFrom( address from,address to,uint256[] memory ids,uint256[] memory amounts) external 
      {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = msg.sender;


        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
               _balances[id][from] = fromBalance - amount;
                _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

      
    }

     function _setApprovalForAll(address owner,address operator,bool approved) external 
      {
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

     function isApprovedForAll(address account, address operator) public view   returns (bool) {
        return _operatorApprovals[account][operator];
        }

       function _mint( address to,uint256 id,uint256 amount) external  {
        require(to != address(0), "ERC1155: mint to the zero address");

        address operator = msg.sender;
        

        

        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0), to, id, amount);

        

       
    }

       function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
        
    ) public {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = msg.sender;

        

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

    
       
    }

    


   

    

       function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
    }
    
                            

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
// ceci mon model de jeton comsomable
contract myFT {

   string name;        //TokenName
   string  symbol;    // TokenSymbol
   address  payable  owner;   //address_proprietaire_jeton --- ownerAddress
   uint256  _totalSupply;   //nombre_de_jeton_en_circulation
   mapping (address => uint256)  balances ;
   mapping (address=> mapping( address =>uint256 ) ) allower;

    event Transfer(address _from, address _to, uint256 _value);
 event Approval(address _owner, address _spender, uint256 _value);

  constructor( )  {
    _totalSupply = 1000000; // initialise_nombre_jeton---
    owner = payable(msg.sender);// passage_address_proprietaire
     balances[msg.sender] = _totalSupply;
      name = "cryptoGaetan";
      symbol = "AFcoin"; }

  function Name() public view returns (string memory) {
    return name;
  }

  function Symbol () public view returns (string memory){
    return symbol;
  }

    function TotalSupply () public view returns ( uint256 ) {
      return  _totalSupply;
    }

    function balanceOf (address _owner) public view returns (uint256 balance) {
      return balances[_owner];
    }

    function tranfer ( address _to, uint256 _value) public returns (bool success) {

      require (_value <=  balances[msg.sender] && owner == msg.sender );
      balances[msg.sender] = balances[msg.sender] - _value;
      balances[_to] = balances[_to]  + _value;
      emit Transfer(msg.sender,  _to , _value);
      return true;
    }

    function approve (address _spender , uint256 _value) public  {
      allower[msg.sender] [_spender] = allower [msg.sender][_spender] + _value;
     emit Approval (msg.sender,_spender,_value) ;/* cette fonction dit que moi et _spender nous partageons la meme value*/
    }
    
    function tranferFrom (address _from,address _to, uint256 _value) public  returns  (bool){
      require (_value <= balances[ _from]);
      require (_value <= allower[_from][msg.sender]) ;
      balances[_from] =balances[_from] - _value;
      allower[_from][msg.sender] = allower [_from][msg.sender] - _value;
      balances[_to] = balances[_to] + _value;
      emit Transfer(_from, _to, _value);
      return true;
    }

      function allowance ( address _owner , address  _spender) public view returns (uint256  remaining) {
        return allower[_owner] [_spender];
      }
// fonction de recption d'ether'
   receive()  external  payable{
     require(msg.value > 0);
     uint256 numOf_token = ((msg.value / 1000000000000000000)* 10);
     balances[msg.sender] = balances[msg.sender] + numOf_token;
     balances[owner] = balances[owner ] - numOf_token;
     owner.transfer(msg.value);
  }


  }

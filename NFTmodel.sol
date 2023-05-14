// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface NFT{

  event Transfer ( address _from,  address to, uint256 tokenId);
  event Approval ( address owner , address Approved , uint256 tokenId);
  event ApprovalOfAll (address owner, address operator , bool approved);

  function balanceOf ( address owner ) external view returns  ( uint256 balance);
  function ownerOf ( uint256 tokenId) external view returns ( address owner );
 // function safeTransferFrom ( address _from , address to , uint256 tokenId , bytes calldata data ) external;
 //function safeTransferFrom ( address _from , address to ,uint256 tokenId ) external ;
  function  transferFrom ( address _from, address to , uint256 tokenId) external;
  function approve (address to , uint256 tokenId) external;
  function setApprovalForAll ( address operator ,bool _approved) external ;
 function  getApproved ( uint256 tokenId)  external view returns ( address operator);
//function isApproved ( address owner, address operator ) external view returns (bool) ;



}

contract NFTmodel  is NFT {
  string private _name;
  string private _symbol;

  mapping ( address => uint256) internal  ownedTokens ;// mapping_address_proprietaire_>>_identiteToken
  mapping ( uint256 => address) internal tokenOwner ;//mapping_identiteToken_>>_address_proprietaire
  mapping(address => uint256) internal ownedTokensCount;//address_>>_nombreToken
  mapping ( address => mapping ( address => bool) ) internal operatorApprovals ; /* la mapping ci-contre fait le mappage sur 2 address, le 1 est _address_proprietaire qui autorise le 2 address_authoriser d'utiliser  son token par bool_vraie_faux */
 mapping ( uint256 => address) internal tokenApprovals ; //mapping changeant _address_proprietaire_token

  constructor( string memory Name, string memory Symbol)  {
    _name = Name;
    _symbol = Symbol;
  }

  function name() public view returns (string memory)  {
    return _name;
  } //fonction printf name

  function symbol () public view returns ( string memory) {
    return _symbol;
  }// fonction printf symbol

  function ownerOf ( uint256 tokenId ) public view returns ( address owner) {
   return tokenOwner [ tokenId] ;
}
function balanceOf ( address owner )  public view returns ( uint256 balance) {
  return ownedTokensCount [ owner];
}

function mint ( address to , uint256 tokenId ) external {
  require ( to != 0 , "l'address ne doit pas etre null") ;
  require ( tokenId > 0 ," token id ne peut pas etre 0 ou moin!");
  ownedTokensCount [ to ]  += 1;
  tokenOwner [ tokenId] = to ;
  ownedTokens [ to] = tokenId ;
   emit Transfer ( msg.sender, to , tokenId);
}

function setApprovalForAll (address operator , bool approved ) external {
  require ( operator != 0 ," operateur ne doit etre 0");
   operatorApprovals [msg.sender] [ operator ] = approved;
} //msg.sender donne authorisation operateur

 function isApprovedAll (address owner , address operator ) public view returns (bool) {
   return operatorApprovals [ owner] [ operator];
}// donne preuve est _approver

 function approve ( address spender , uint256  tokenId) external {
   require ( tokenId > 0 ," jeton non zero");
   require ( spender != address(0) ," address_pas zero");//address(),uint(),byte()==conversion_en_address_int_byte
   address owner = tokenOwner[tokenId];
   require ( msg.sender == owner || operatorApprovals[owner][msg.sender] ," pas authorisation pour cette action");
   tokenApprovals[tokenId] = spender ;
   emit Approval ( owner ,spender , tokenId) ;
}// fonction qui change la ownership du token

function getApproved (uint256 tokenId) public view returns ( address spender ) {
  return tokenApprovals [tokenId];
}

function safeTransferFrom  ( address _from, address to, uint256 tokenId /*, bytes32  data */) public {
  uint length;
  assembly {
    length := extcodesize (to)
  }
  transferFrom ( _from , to ,tokenId) ;

}

 function transferFrom (address _from, address to , uint256 tokenId ) public {
   require ( _from != address(0) , " address pas zero");
   require ( to != address(0),"faute address");
   require (tokenId > 0,"jeton pas 0");
   require (  ownedTokensCount[_from]  > 0," from address devrait etre un own du jeton") ;
   ownedTokensCount [ _from] = ownedTokensCount [_from] - 1 ;
   ownedTokensCount [ to] = ownedTokensCount [ to] + 1 ;

   tokenOwner [ tokenId] =  address(0) ;
   tokenApprovals [tokenId] = address(0) ;
   tokenOwner [tokenId] = to ;
   ownedTokens [to] = tokenId ;
   emit Transfer ( _from , to, tokenId );
}
}


















// SPDX-License-Identifier: MIT


pragma solidity ^0.8.26;


contract JamToken{

 //DECLARACIONES
 string public name = "JAM token";
 string public symbol="JAM";
 uint256 public totalsupply =100000000000000000000000;
 uint8 public decimals = 18;


 //evento para la transferencia de tokens de un usuario

 event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
 );
 // un evento para la aprobacion de un operador
 event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 value
 );
 // estructuras de datos 

 mapping (address=>uint256) public balanceOf;
 mapping (address => mapping(address =>uint256)) private _allowance;

 constructor() {
    balanceOf[msg.sender] = totalsupply;
 }

 //transferencia de tokens de un usuario

    function transfer(address _to, uint256 _value)public virtual returns(bool){

            require(balanceOf[msg.sender] >= _value, "TRANSFER:not enough fonds");

                unchecked{

                    balanceOf[_to] += _value;

                    balanceOf[msg.sender] -= _value;

                }

                emit Transfer(msg.sender, _to, _value);
                return  true ;
            



    }



    function transferFrom(address _from, address _to, uint256 _value)public virtual returns(bool){

                
                require(balanceOf[_from] >= _value, "TRANSFER:not enough fonds");
                //from(owner), msg.sender(spender)
                require(_allowance[_from][msg.sender] >= _value,"asdasdasd");
                
                unchecked{
                    balanceOf[_from] -= _value;
                    balanceOf[_to] += _value;
                    _allowance[_from][msg.sender] -= _value;
                
                }
                emit Transfer(_from, _to, _value);
                return true;


    }

    // Aprobacion de una cantidad para ser gastada por un operador


    function approve( address _spender, uint256 _value)public virtual returns (bool){

        _allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }




}
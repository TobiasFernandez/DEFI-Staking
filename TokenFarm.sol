
// SPDX-License-Identifier: MIT

// owner : 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//user :0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
pragma solidity ^0.8.26;

import "./JamToken.sol";
import "./StellarToken.sol";


contract TokenFarm{



    string public name = "Stellar Token Farm";
    address public owner;
    JamToken public jamtoken;
    StellarToken public stellarToken;


    // estructuras de datos
    address [] public stakers;

    mapping(address => uint256) public StakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(StellarToken _stellarToken,JamToken _jamToken){
            stellarToken =_stellarToken;
            jamtoken =_jamToken;
            owner = msg.sender;

    }

    function stakeTokens(uint256 _amount)public{

        //se require una cantidad superior a 0
        require(_amount > 0,"ERC20:Staking tokens cant be Zero");
        //transferir tokens JAM al smart contract principal

        jamtoken.transferFrom(msg.sender, address(this), _amount );
        //actualizar el saldo del staking
        StakingBalance[msg.sender] += _amount;
        //comprobar si esa persona hizo staking. y guardar el staker

        if (!hasStaked[msg.sender]){
                stakers.push(msg.sender);
        }

        isStaking[msg.sender]= true;
        hasStaked[msg.sender]= true;


    }

    // Quitar el staking de los toknes

    function unstakeTokens()public{


        uint256 balance = StakingBalance[msg.sender];

        require(balance > 0,"ERC20:Staked tokens cant be Zero");

        //transferencia de los tokens al usuario

        jamtoken.transfer(msg.sender,balance);

        //resetea el balance de staking del usuario


        StakingBalance[msg.sender] = 0;
        //actualizar el estado del staking
        isStaking[msg.sender]= false;

                

    }

    //Emision de tokens(recompensas)

    function issueTokens()public{
            //unicamente ejectuble por el owner
            require(msg.sender == owner,"No eres el owner");
            //emitir tokens a todos los stakers


            for (uint i =0; i < stakers.length; i++) {
                address recipient = stakers[i];
                uint balance = StakingBalance[recipient];

                if (balance > 0){
                    uint256  profit = balance /10;
                    stellarToken.transfer(recipient, profit );
                }

            }




    }



}
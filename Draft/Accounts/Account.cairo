
use starknet::ContractAddress;

struct Call {
    to : ContractAddress,
    selector: felt252,
    calldata :Array<felt252>
}


#[account_contract]
mod Account{
   use super::ContractCall;
   use array::ArrayTrait;
   use array::SpanTrait;
   use zeroable::Zeroable;
   use starknet::contract_address::ContractAddressZeroable;
        
        #[external]
        fn __validate__ ()->felt252{
            validate_tx()
        
        }

       #[external]
       fn __validate_declare__(calls:Array<Call>)->felt252 {
          validate_tx()
       }
       #[external]
        fn __validate_deploy__(class_hash: felt252, contract_address_salt: felt252, _public_key: felt252) -> felt252 {
            validate_tx()
        }

        fn validate_tx()->felt252{
           let tx_info =starknet::get_tx_info().unbox();
            let signature =tx_info.signature;
            let transaction_hash =tx_info.transaction_hash;
            assert(logic_that_verifies_signature(transaction_hash,signature),'ERROR : INVALID SIGNATURE')
            starknet::VALIDATED
        }
        

        #[external]
        fn __execute__(calls:Array<Call>) -> Array<Span<felt252>>{
           //the caller of the contract
           let caller = starknet::get_caller_address();
          //    verifies that the caller is not the zero address
           assert(caller.is_zero(),'ERROR: CALL FROM ZERO ADDRESS');
           multi_contract_calls(calls)
        }
            

            
        fn multi_contract_calls(mut calls:Array<ContractCall>)->Array<Span<felt252>>{
           
            let mut result: Array<Span<felt252>> = ArrayTrait::new();
            let mut calls = calls;
            // loops through the call array
            loop {
                //gets the firt item
                match calls.pop_front() {
                    Option::Some(call) => {
                        //low level function for calling contracts
                        let ret_data=call_contract_syscall(*call.to, *call.selector, call.calldata.span()).unwrap_syscall();
                        result.append(ret_data);
                       
                    },
                    Option::None(_) => {
                        break();
                    },
                };
            };
            result
    }
          
        

        
        fn logic_that_verifies_signature(message_hash:felt252,signature:Span<felt252>)->bool{
          if signature.len() == 2_u32 {
             return ecdsa::check_ecdsa_signature(message_hash,public_key::read(),*signature.at(0_u32),*signature.at(1_u32));
          }
           return false;
        }

}
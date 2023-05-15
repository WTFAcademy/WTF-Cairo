
use starknet::ContractAddress;

struct ContractCall {
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

        fn __validate__ ()->felt252{
            let tx_info =starknet::get_tx_info().unbox();
            let signature =tx_info.signature;
            let transaction_hash =tx_info.transaction_hash;
            assert(logic_that_verifies_signature(transaction_hash,signature),'ERROR : INVALID SIGNATURE')
            starknet::VALIDATED
        
        }
        fn __execute__(calls:Array<ContractCall>) -> Array<Span<felt252>>{
           //the caller of the contract
           let caller = starknet::get_caller_address();
          //    verifies that the caller is not the zero address
           assert(caller.is_zero(),'ERROR: CALL FROM ZERO ADDRESS');
           multi_contract_calls(calls,ArrayTrait::new())
        }
            

            
        fn multi_contract_calls(mut calls:Array<ContractCall>,mut result:Array<Span<felt252>>)->Array<Span<felt252>>{
            //pop_front removes the first element in the array
            //it returns an Option
            match calls.pop_front(){
                        //destructuring the Option
                        Option::Some(call)=> {
                            let res=single_contract_call(call);
                            //uses recursion beacause loops are not fully supported currently
                            return multi_contract_calls(calls,res);

                        },
                        Option::None(_) =>{return result;}
            }
        }

        fn single_contract_call(call:ContractCall)->Array<Span<felt252>>{
            let Call { to ,selector , calldata} = calls;
            starknet::call_contract_syscall(to,selector,calldata.span()).unwrap_syscall()
        }
        
        fn logic_that_verifies_signature(message_hash:felt252,signature:Span<felt252>)->bool{
          if signature.len() == 2_u32 {
             return ecdsa::check_ecdsa_signature(message_hash,public_key::read(),*signature.at(0_u32),*signature.at(1_u32));
          }
           return false;
        }

}
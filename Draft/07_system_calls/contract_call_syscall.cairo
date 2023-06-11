#[contract]
mod ContractCalls {
    use starknet::call_contract_syscall;
    use starknet::ContractAddress;
    use array::SpanTrait;
    
    #[external]
    fn call(address: ContractAddress, selector: felt252, calldata: Array<felt252>)-> Span::<felt252>{
        call_contract_syscall(address, selector, calldata.span()).unwrap_syscall()
    }
}
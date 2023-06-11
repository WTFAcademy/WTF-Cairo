#[contract]
mod LibaryCalls {
    use starknet::library_contract_syscall;
    use starknet::ClassHash;
    use array::SpanTrait;
    
    #[external]
    fn library_call(class_hash: ClassHash, selector: felt252, calldata: Array<felt252>)-> Span::<felt252>{
        library_call_syscall(class_hash,entry_point_selector,calldata.span()).unwrap_syscall()
    }
}
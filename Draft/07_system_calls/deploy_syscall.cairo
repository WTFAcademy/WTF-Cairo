#[contract]
mod Deployer {
    use starknet::deploy_syscall;
    use starknet::ContractAddress;
    use starknet::ClassHash;
    
    #[external]
    fn deploy(class_hash: ClassHash, contract_address_salt: felt252, calldata: Span<felt252>, deploy_from_zero: bool,)-> (ContractAddress, Span::<felt252>){
        deploy_syscall(class_hash,contract_address_salt,calldata,deploy_from_zero).unwrap_syscall()
    }
}
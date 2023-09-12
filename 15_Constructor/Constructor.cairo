#[starknet::contract]
mod owner{
    // import contract address related libraries
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    // storage variable
    #[storage]
    struct Storage{
        owner: ContractAddress,
    }

    // set owner address during deploy
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }
}
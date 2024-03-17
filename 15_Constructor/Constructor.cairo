#[starknet::contract]
mod owner{
    // import contract address related libraries
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    // storage variable
    #[storage]
    struct Storage{
        owner: ContractAddress,
        balance: felt252,
    }

    // set owner address during deploy
    #[constructor]
    fn constructor(ref self: ContractState, balance_: felt252) {
        self.owner.write(get_caller_address());
        self.balance.write(balance_);
    }

    #[external(v0)]
    fn balance_read(self: @ContractState) -> felt252 {
        self.balance.read()
    }
}

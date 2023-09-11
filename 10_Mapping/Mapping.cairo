#[starknet::contract]
mod mapping_example {
    use starknet::ContractAddress;

    // balances storage variable: map from account address to u256
    #[storage]
    struct Storage{
        balances: LegacyMap::<ContractAddress, u256>,
    }

    // read balance
    #[external(v0)]
    fn read_balance(self: @ContractState, account: ContractAddress) -> u256 {
        self.balances.read(account)
    }

    // update balance
    #[external(v0)]
    fn write_balance(ref self: ContractState, account: ContractAddress, new_balance: u256){
        self.balances.write(account, new_balance);
    }
}
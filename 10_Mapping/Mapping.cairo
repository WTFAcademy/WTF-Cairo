#[contract]
mod mapping_example {
    use starknet::ContractAddress;

    // balances storage variable: map from account address to u256
    struct Storage{
        balances: LegacyMap::<ContractAddress, u256>,
    }

    // read balance
    #[view]
    fn read_balance(account: ContractAddress) -> u256 {
        balances::read(account)
    }

    // update balance
    #[external]
    fn write_balance(account: ContractAddress, new_balance: u256){
        balances::write(account, new_balance);
    }
}

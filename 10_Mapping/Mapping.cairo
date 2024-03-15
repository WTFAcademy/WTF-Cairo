#[starknet::contract]
mod map_and_dictionaries {

    use starknet::ContractAddress;
    
    #[storage]
    struct Storage {
        balances: LegacyMap::<ContractAddress, felt252>,
        allowance: LegacyMap::<(ContractAddress,ContractAddress), felt252>
    }

    #[external(v0)]
    fn read_balance(self: @ContractState, account: ContractAddress) -> felt252 {
        self.balances.read(account)
    }

    #[external(v0)]
    fn write_balance(ref self: ContractState, account: ContractAddress, new_balance: felt252){
        self.balances.write(account, new_balance);
    }

    #[external(v0)]
    fn dictionaries(self: @ContractState) -> u64{
        let mut balances: Felt252Dict<u64> = Default::default();

        balances.insert('Alex',100);
        balances.insert('Maria',200);

        let alex_balance = balances.get('Alex');
        return alex_balance;
    }

    #[external(v0)]
    fn dictionaries_extern(self: @ContractState) -> (u64,u64){
        let mut balances: Felt252Dict<u64> = Default::default();

        balances.insert('Alex',100);

        let alex_balance_first = balances.get('Alex');

        balances.insert('Alex',200);

        let alex_balance_second = balances.get('Alex');
        return (alex_balance_first,alex_balance_second);
    }

}

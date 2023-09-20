use starknet::ContractAddress;

#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;

    fn symbol(self: @TContractState) -> felt252;

    fn decimals(self: @TContractState) -> u8;

    fn total_supply(self: @TContractState) -> u256;

    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;

    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;

    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}

#[starknet::interface]
trait IMiniERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod mini_erc_20 {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
    }


    #[constructor]
    fn constructor(
        ref self: ContractState,
        name_: felt252,
        symbol_: felt252,
    ) {
        self.name.write(name_);
        self.symbol.write(symbol_);
    }

    // 包含在interface中的external function
    #[external(v0)]
    impl IERC20Impl of super::IMiniERC20<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }
    }

    // 没包含在interface中的external function
    #[external(v0)]
    fn set_name(
        ref self: ContractState, new_name: felt252
    ) {
        self.name.write(new_name);
    }

    // 没包含在interface中的internal function
    #[generate_trait]
    impl StorageImpl of StorageTrait {
        fn set_symbol(
            ref self: ContractState, new_symbol: felt252
        ) {
            self.symbol.write(new_symbol);
        }
    }
}
use starknet::ContractAddress;
#[starknet::interface]
trait IMiniERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod librarycall_mini_erc_20 {
    use starknet::ContractAddress;
    use super::IMiniERC20DispatcherTrait;
    use super::IMiniERC20LibraryDispatcher;

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

    #[external(v0)]
    fn get_name(self: @ContractState, class_hash: starknet::ClassHash) -> felt252 {
        IMiniERC20LibraryDispatcher { class_hash }.name()
    }

    #[external(v0)]
    fn get_symbol(self: @ContractState, class_hash: starknet::ClassHash) -> felt252 {
        IMiniERC20LibraryDispatcher { class_hash }.symbol()
    }
}
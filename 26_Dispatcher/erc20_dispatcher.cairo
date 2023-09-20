use starknet::ContractAddress;
#[starknet::interface]
trait IMiniERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod call_mini_erc_20 {
    use starknet::ContractAddress;
    use super::IMiniERC20DispatcherTrait;
    use super::IMiniERC20Dispatcher;

    #[storage]
    struct Storage {
    }

    #[external(v0)]
    fn get_name(self: @ContractState, contract_address: ContractAddress) -> felt252 {
        IMiniERC20Dispatcher { contract_address }.name()
    }

    #[external(v0)]
    fn get_symbol(self: @ContractState, contract_address: ContractAddress) -> felt252 {
        IMiniERC20Dispatcher { contract_address }.symbol()
    }
}
use starknet::{ContractAddress, ClassHash, contract_address_const};
use openzeppelin_interfaces::token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
use snforge_std::{declare, ContractClass, ContractClassTrait, DeclareResultTrait};
use core::num::traits::Zero;

fn deploy_erc20mock_contract(
    name: ByteArray,
    symbol: ByteArray,
    decimals: u8,
    class_hash: ClassHash,
    recipient: ContractAddress,
    fixed_supply: u256
) -> ERC20ABIDispatcher {
    let contract_class = if class_hash == Zero::zero() {
        declare("ERC20Mock").unwrap().contract_class()
    } else {
        @ContractClass { class_hash }
    };
    let mut constructor_calldata = array![];
    Serde::serialize(@name, ref constructor_calldata);
    Serde::serialize(@symbol, ref constructor_calldata);
    Serde::serialize(@decimals, ref constructor_calldata);
    Serde::serialize(@recipient, ref constructor_calldata);
    Serde::serialize(@fixed_supply, ref constructor_calldata);
    let (address, _) = contract_class.deploy(@constructor_calldata).expect('Failed to deploy');
    ERC20ABIDispatcher { contract_address: address }
}

#[test]
fn test_erc20mock() {
    let name = "tnt";
    let symbol = "TNT";
    let decimals = 20;
    let recipient = contract_address_const::<0x123>();
    let fixed_supply = 1234567890;
    let dispatcher = deploy_erc20mock_contract(
        name, symbol, decimals, Zero::zero(), recipient, fixed_supply
    );

    assert(dispatcher.name() == "tnt", 'wrong name');
    assert(dispatcher.symbol() == "TNT", 'wrong symbol');
    assert(dispatcher.decimals() == 20, 'wrong decimals');
    assert(dispatcher.total_supply() == 1234567890, 'wrong supply');
    assert(dispatcher.balance_of(recipient) == fixed_supply, 'wrong balance');
}

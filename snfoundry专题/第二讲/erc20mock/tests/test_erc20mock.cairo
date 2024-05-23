use starknet::{ContractAddress, ClassHash, contract_address_const};
use openzeppelin::token::erc20::interface::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
use snforge_std::{declare, ContractClass, ContractClassTrait};
use core::num::traits::Zero;
use openzeppelin::utils::serde::SerializedAppend;

fn deploy_erc20mock_contract(
    name: ByteArray,
    symbol: ByteArray,
    decimals: u8,
    class_hash: ClassHash,
    recipient: ContractAddress,
    fixed_supply: u256
) -> ERC20ABIDispatcher {
    let contract_class = if class_hash == Zero::zero() {
        declare("ERC20Mock").expect('Declare failed')
    } else {
        ContractClass { class_hash }
    };
    let mut constructor_calldata = array![];
    constructor_calldata.append_serde(name);
    constructor_calldata.append_serde(symbol);
    constructor_calldata.append_serde(decimals);
    constructor_calldata.append_serde(recipient);
    constructor_calldata.append_serde(fixed_supply);
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

    assert_eq!(dispatcher.name(), "tnt");
    assert_eq!(dispatcher.symbol(), "TNT");
    assert_eq!(dispatcher.decimals(), 20);
    assert_eq!(dispatcher.total_supply(), 1234567890);
}

use starknet::ContractAddress;
struct Call {
    to : ContractAddress,
    selector: felt252,
    calldata :Array<felt252>
}
trait IAccount {
        fn get_public_key() -> felt252;
    
        fn supports_interface(interfaceId: felt252) -> bool;
        

        fn set_public_key(newPublicKey: felt252)->();

        fn is_valid_signature_(message_hash: felt252,signature: Span<felt252>) -> bool;

    fn __validate__(calls:Array<Call>)->felt252;
    
    fn __validate_declare__(calls:Array<Call>)->felt252;
        
    fn __execute__(calls:Array<Call>)->Array<Span<felt252>>;
}

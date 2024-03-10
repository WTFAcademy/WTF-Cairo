#[starknet::contract]
mod mutable_and_const {

    const CONST_NUMBER: felt252 = 888;
    const CONST_ONE_HOUR: u32 = consteval_int!(60 * 60);
    // error: Function call is not supported outside of functions.
    // error: Only literal constants are currently supported.
    //const CONST_ONE_HOUR_SECOND: u32 = 60 * 60;
    
    //error: Only literal constants are currently supported.
    //const CONST_BOOL: bool = true;
    //error: A literal of type core::bool cannot be created.
    //error: Mismatched types. The type `core::bool` cannot be created from a numeric literal.
    //const CONST_BOOL: bool = 1;

    const CONST_CHAR: felt252 = 'C';
    const CONST_CHAR_IN_HEX: felt252 = 0x43;
    const CONST_STRING: felt252 = 'Hello world';
    const CONST_STRING_IN_HEX: felt252 = 0x48656C6C6F20776F726C64;

    //error: Only literal constants are currently supported.
    //const CONST_LONG_STRING: ByteArray = "this is a string which has more than 31 characters";

    #[storage]
    struct Storage{
    }

    #[external(v0)]
    fn immutable(self: @ContractState) {
        // 在 Cairo 中，变量默认是不可变的
        let _x_immutable = 5;
        // 下面的代码将导致错误
        //x_immutable = 10;
    }

    fn mutable(self: @ContractState) {
        // 使用 `mut` 关键字声明可变变量
        let mut _x_mutable = 5;
        _x_mutable = 10;
    }

    #[external(v0)]
    fn const_variably(self: @ContractState) {
        // 可以将常量赋给变量
        let _y_immutable = CONST_ONE_HOUR + 2;
    }

    #[external(v0)]
    fn shadow(self: @ContractState) -> felt252 {
        // shadow: you can declare a new variable with the same name as previous ones.
        let _x_shadow = 5;
        // you can change the data type or mutability with shadowing
        let _x_shadow = 10_u8;
        let mut _x_shadow = 15;
        return _x_shadow;
    }
}

#[starknet::contract]
mod mutable_and_const {
    const CONST_NUMBER: felt252 = 888;
    
    #[storage]
    struct Storage{
    }

    #[external(v0)]
    fn mutable_and_const(self: @ContractState) -> (felt252, felt252, felt252){
        // in Cairo, variables are immutable by default
        let x_immutable = 5;
        // because x is immutable by default, following code will result in error
        // x_immutable = 10

        // use `mut` keyword to declare mutable variables
        let  mut x_mutable = 5;
        x_mutable = 10;

        // you can assign const to a variable
        let y_immutable = CONST_NUMBER + 2;
        return (x_immutable, x_mutable, y_immutable);
    }

    #[external(v0)]
    fn shadow(self: @ContractState) -> felt252 {
        // shadow: you can declare a new variable with the same name as previous ones.
        let x_shadow = 5;
        // you can change the data type or mutability with shadowing
        let x_shadow = 10_u8;
        let mut x_shadow = 15;
        return x_shadow;
    }
}
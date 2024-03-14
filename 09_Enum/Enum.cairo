#[starknet::contract]
mod enum_example {
    #[storage]
    struct Storage{
        dir: Direction
    }

    #[derive(Drop, Serde, starknet::Store)]
    enum Direction {
        North: u128,
        East: u128,
        South: u128,
        West: u128,
    }

    #[derive(Drop, Serde)]
    enum Colors { 
        Red: (), 
        Green: (), 
        Blue: (),
        None,
    }

    #[derive(Copy, Drop)]
    enum Actions { 
        Forward, 
        Backward: u128, 
        Stop: (felt252,felt252),
        None,
    }

    #[external(v0)]
    fn get_red(self: @ContractState) -> Colors {
        Colors::Red(())
    }

    #[external(v0)]
    fn create_enum(self: @ContractState) {
        // create enum
        let _Backward = Actions::Backward((1_u128));
        let _red = get_red(self);
    }
}

#[starknet::contract]
mod enum_example {
    #[storage]
    struct Storage{
        }

    #[derive(Copy, Drop, Serde)]
    enum Colors { 
        Red: (), 
        Green: (), 
        Blue: (), 
        }

    #[derive(Copy, Drop)]
    enum Actions { 
        Forward: u128, 
        Backward: u128, 
        Stop: (),
        }

    // return red color
    #[external(v0)]
    fn get_red(self: @ContractState) -> Colors {
        Colors::Red(())
    }

    #[external(v0)]
    fn create_enum(self: @ContractState) {
        // create enum
        let forward = Actions::Forward((1_u128));
        let red = get_red(self);
    }
}
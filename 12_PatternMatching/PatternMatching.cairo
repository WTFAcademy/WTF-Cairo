#[starknet::contract]
mod pattern_matching{
    #[storage]
    struct Storage{
    }

    #[derive(Drop, Serde)]
    enum Colors { 
        Red: (), 
        Green: (), 
        Blue: (), 
        }

    #[derive(Drop, Serde)]
    enum Actions { 
        Forward: u128, 
        Stop: (),
        }

    // return red color
    #[external(v0)]
    fn get_red(self: @ContractState) -> Colors {
        Colors::Red(())
    }

    // return forward action
    #[external(v0)]
    fn get_forward(self: @ContractState, dist: u128) -> Actions {
        Actions::Forward(dist)
    }

    // match pattern (Colors)
    #[external(v0)]
    fn match_color(self: @ContractState, color: Colors) -> u8 {
        match color {
            Colors::Red(()) => 1_u8,
            Colors::Green(()) => 2_u8,
            Colors::Blue(()) => 3_u8,
        }
    }

    // match color example, should return 1_u8
    #[external(v0)]
    fn match_red(self: @ContractState, ) -> u8 {
        let color = get_red(self);
        match_color(self, color)
    }

    // match pattern with data (Actions)
    #[external(v0)]
    fn match_action(self: @ContractState, action: Actions) -> u128 {
        match action {
            Actions::Forward(dist) => {
                dist
            },
            Actions::Stop(_) => {
                0_u128
            }
        }
    }

    // match action example, should return 2_u128
    #[external(v0)]
    fn match_forward(self: @ContractState) -> u128 {
        let action = get_forward(self, 2_u128);
        match_action(self, action)
    }
}
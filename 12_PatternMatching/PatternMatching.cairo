#[starknet::contract]
mod pattern_matching{
    #[storage]
    struct Storage{
    }

    #[derive(Drop, Serde)]
    enum Colors { 
        Red, 
        Green, 
        Blue, 
    }

    // 返回 red color
    fn get_red() -> Colors {
        Colors::Red
    }

    // 模式匹配 (Colors)
    fn match_color(color: Colors) -> u8 {
        match color {
            Colors::Green => 1_u8,
            Colors::Blue => 2_u8,
            Colors::Red => 3_u8,
        }
    }

    // Color匹配例子，返回1_u8
    #[external(v0)]
    fn match_red(self: @ContractState) -> u8 {
        let color = get_red();
        match_color(color)
    }

    fn match_color_second(color: Colors) -> u8 {
        match color {
            Colors::Green | Colors::Blue => 1_u8,
            _ => 2_u8,
        }
    }

    #[external(v0)]
    fn match_test(self: @ContractState) -> (u8,u8) {
        let color_1 = Colors::Red;
        let color_2 = Colors::Blue;
        let u_1 = match_color_second(color_1);
        let u_2 = match_color_second(color_2);
        return (u_1,u_2);
    }

    #[derive(Drop, Serde)]
    enum Actions { 
        Forward: u128, 
        Stop,
    }

    // 返回 forward 动作
    fn get_forward(dist: u128) -> Actions {
        Actions::Forward(dist)
    }

    // match pattern with data (Actions)
    fn match_action(action: Actions) -> u128 {
        match action {
            Actions::Forward(dist) => {
                dist
            },
            Actions::Stop => {
                0_u128
            }
        }
    }

    // 匹配行动例子, 返回 2_u128
    #[external(v0)]
    fn match_forward(self: @ContractState) -> u128 {
        let action = get_forward(2_u128);
        match_action(action)
    }

    #[external(v0)]
    fn match_tuple(self: @ContractState) -> bool {
        let color = Colors::Red;
        let action = Actions::Forward(2_u128);
        match (color, action) {
            (Colors::Blue, _) => true,
            (_, Actions::Stop) | (Colors::Red, Actions::Forward) => true,
            (_, _) => false,
        }
    }

    #[external(v0)]
    fn match_felt252(self: @ContractState, value: u8) -> u8 {
        match value {
            0 => 1,
            _ => 0,
        }
    }

}

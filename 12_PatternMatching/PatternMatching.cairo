#[contract]
mod pattern_matching{
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
    #[view]
    fn get_red() -> Colors {
        Colors::Red(())
    }

    // return forward action
    #[view]
    fn get_forward(dist: u128) -> Actions {
        Actions::Forward(dist)
    }

    // match pattern (Colors)
    #[view]
    fn match_color(color: Colors) -> u8 {
        match color {
            Colors::Red(()) => 1_u8,
            Colors::Green(()) => 2_u8,
            Colors::Blue(()) => 3_u8,
        }
    }

    // match color example, should return 1_u8
    #[view]
    fn match_red() -> u8 {
        let color = get_red();
        match_color(color)
    }

    // match pattern with data (Actions)
    #[view]
    fn match_action(action: Actions) -> u128 {
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
    #[view]
    fn match_forward() -> u128 {
        let action = get_forward(2_u128);
        match_action(action)
    }
}
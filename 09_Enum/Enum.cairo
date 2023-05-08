#[contract]
mod enum_example {
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
    #[view]
    fn get_red() -> Colors {
        Colors::Red(())
    }

    #[view]
    fn create_enum() {
        // create enum
        let forward = Actions::Forward((1_u128));
        let red = get_red();
    }
}

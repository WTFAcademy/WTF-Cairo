#[contract]
mod HelloCairo {
    // declare storage variables
    struct Storage{
        balance: u128,
        }
    
    // private function, can not be accessed externally
    fn sum_two(x: u128, y: u128) -> u128 {
        return x + y;
    }

    // view function: can read but not write storage variables.
    #[view]
    fn read_balance() -> u128 {
        return balance::read();
    }

    // external: can read and write storage variables.
    #[external]
    fn write_balance(new_balance: u128) {
        balance::write(new_balance);
    }
}
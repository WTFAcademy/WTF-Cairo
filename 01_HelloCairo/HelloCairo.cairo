#[contract]
mod HelloCairo {
    #[view]
    fn hello_cairo() -> felt252 {
        return 'Hello Cairo!';
    }
}
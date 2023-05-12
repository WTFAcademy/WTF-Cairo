#[contract]
mod event_example{
    // define an event
    #[event]

    fn Transfer(from_: felt, to: felt, value: u256) {}

    #[external]
    fn emit_event_example(from: felt, to: felt, value: u256) {
        Transfer(from, to ,value)
    }

}
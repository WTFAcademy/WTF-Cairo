#[starknet::contract]
mod tuple_reverse {
    #[storage]
    struct Storage{
        }

    // Tuples can be used as function arguments and as return values.
    #[external(v0)]
    fn reverse(self: @ContractState, pair: (u32, bool)) -> (bool, u32) {
        // Unpacking: `let` can be used to bind the members of a tuple to variables.
        let (integer, boolean) = pair;
        return (boolean, integer);
    }
}
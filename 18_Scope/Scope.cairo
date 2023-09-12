#[starknet::contract]
mod ownership_scope{
    #[storage]
    struct Storage{
    }

    fn scope_function() {
        let x = 'hello';   // x comes into scope

        // x can be used here
        let y = x;

    } // x goes out of scope and is dropped here

    fn scope_nested() {
        let outer_var = 'outer'; // outer_var is in the outer scope

        {
            let inner_var = 'inner'; // inner_var is in the inner scope
        }

        // inner_var is out of scope here

        // outer_var is still in scope here
        let x = outer_var;
    }
}
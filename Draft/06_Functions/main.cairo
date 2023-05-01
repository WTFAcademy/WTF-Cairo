#[contract]
mod ERC20 {

    //////////////////
    // Event Function
    //////////////////
    #[event]
    fn Update_Counter(counter: u32){}

    //////////////////
    // Storage
    //////////////////
    struct Storage {
        name: felt252,
        symbol: felt252,
        counter: u32,
    }

    //////////////////
    // Constructor 
    //////////////////

    #[constructor]
    fn constructor(
        name_: felt252, 
        symbol_: felt252,
        ) 
        {
        name::write(name_);
        symbol::write(symbol_);
    }

    //////////////////
    // View Functions
    //////////////////

    #[view]
    fn get_symbol() -> felt252 {
        symbol::read()
    }

    //////////////////
    // External Functions
    //////////////////

    #[external]
    fn increase_counter() {
        let current_counter = counter::read();
        counter::write(current_counter + 1_u32);
        Update_Counter(counter::read());
    }

    #[external]
    fn reset_conter() {
        internal_function();
    }

    //////////////////
    // Internal Function
    //////////////////
    fn internal_function(){
        counter::write(0_u32);
    }
}
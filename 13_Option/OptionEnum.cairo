#[starknet::contract]
mod option_enum{
    use option::OptionTrait;

    #[storage]
    struct Storage{
    }

    // create Some Option
    fn create_some() -> Option<u8> {
        let some_value: Option<u8> = Option::Some(1_u8);
        some_value
    }

    // create None Option
    fn create_none() -> Option<u8> {
        let none_value: Option<u8> = Option::None(());
        none_value
    }   

    // get value from Some using unwrap()
    #[external(v0)]
    fn get_value_from_some(self: @ContractState) -> u8 {
        let some_value = create_some();
        some_value.unwrap()
    }

    // handle option with is_some() and is_none()
    #[external(v0)]
    fn handle_option_1(self: @ContractState, option: Option<u8>) -> u8 {
        // is_some() Returns `true` if the `Option` is `Option::Some`.
        // is_none()  Returns `true` if the `Option` is `Option::None`.
        if option.is_some() {
            option.unwrap()
        } else {
            0_u8
        }
    }

    // handle option with match
    #[external(v0)]
    fn handle_option_2(self: @ContractState, option: Option<u8>) -> u8 {
        match option{
            Option::Some(value) => value,
            Option::None(_) => 0_u8,
        }
    }
}
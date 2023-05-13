#[contract]
mod owner_event{
    // import contract address related libraries
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    // storage variable
    struct Storage{
        owner: ContractAddress,
    }

    // set owner address during deploy
    #[constructor]
    fn constructor() {
        owner::write(get_caller_address());
    }

    /// Event emitted when owner is changed
    #[event]
    fn ChangeOwner(old_owner: ContractAddress, new_owner: ContractAddress) {}

    // read owner address
    #[view]
    fn read_owner() -> ContractAddress{
        owner::read()
    }

    // change owner address and emit ChangeOwner event
    // can be called by anyone)
    #[external]
    fn change_owner(new_owner: ContractAddress){
        let old_owner = owner::read();
        owner::write(new_owner);
        // emit event by calling event function
        ChangeOwner(old_owner, new_owner);
    }
}
#[starknet::contract]
mod owner_event{
    // import contract address related libraries
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    /// Event emitted when owner is changed
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ChangeOwner: ChangeOwner,
    }

    #[derive(Drop, starknet::Event)]
    struct ChangeOwner {
        #[key]
        old_owner: ContractAddress,
        new_owner: ContractAddress
    }

    // storage variable
    #[storage]
    struct Storage{
        owner: ContractAddress,
    }

    // set owner address during deploy
    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
    }

    // read owner address
    #[external(v0)]
    fn read_owner(self: @ContractState) -> ContractAddress{
        self.owner.read()
    }

    // change owner address and emit ChangeOwner event
    // can be called by anyone
    #[external(v0)]
    fn change_owner(ref self: ContractState, new_owner: ContractAddress){
        let old_owner = self.owner.read();
        self.owner.write(new_owner);
        // emit event by calling event function
        self.emit(ChangeOwner {old_owner: old_owner, new_owner: new_owner});
    }
}
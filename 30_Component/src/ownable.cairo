use starknet::ContractAddress;

#[starknet::interface]
trait IOwnable<TContractState> {
    fn owner(self: @TContractState) -> ContractAddress;
    fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
    fn renounce_ownership(ref self: TContractState);
}


#[starknet::component]
pub mod ownable_component {
    use starknet::{ ContractAddress, get_caller_address };
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        owner: ContractAddress,
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Ownership_transferred: Ownership_transferred,
    }

    #[derive(Drop, starknet::Event)]
    struct Ownership_transferred {
        #[key]
        previous_owner: ContractAddress,
        #[key]
        new_owner: ContractAddress,
    }

    mod Errors {
        pub const NOT_OWNER: felt252 = 'Caller is not the owner';
        pub const NOT_PENDING_OWNER: felt252 = 'Caller is not the pending owner';
        pub const ZERO_ADDRESS_CALLER: felt252 = 'Caller is the zero address';
        pub const ZERO_ADDRESS_OWNER: felt252 = 'New owner is the zero address';
    }

    #[embeddable_as(Ownable)]
    impl OwnableImpl<TContractState, +HasComponent<TContractState>> of super::IOwnable<ComponentState<TContractState>> {
        fn owner(self: @ComponentState<TContractState>) -> ContractAddress {
            self.owner.read()
        }

        fn transfer_ownership(ref self: ComponentState<TContractState>, new_owner: ContractAddress) {
            assert(!new_owner.is_zero(), Errors::ZERO_ADDRESS_OWNER);
            self.assert_only_owner();
            self._transfer_ownership(new_owner);
        }
        fn renounce_ownership(ref self: ComponentState<TContractState>) {
            self.assert_only_owner();
            self._transfer_ownership(Zero::zero());
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>, owner: ContractAddress) {
            self._transfer_ownership(owner);
        }

        fn assert_only_owner(self: @ComponentState<TContractState>) {
            let owner: ContractAddress = self.owner.read();
            let caller: ContractAddress = get_caller_address();
            assert(!caller.is_zero(), Errors::ZERO_ADDRESS_CALLER);
            assert(caller == owner, Errors::NOT_OWNER);
        }

        fn _transfer_ownership(
            ref self: ComponentState<TContractState>, new_owner: ContractAddress
        ) {
            let previous_owner: ContractAddress = self.owner.read();
            self.owner.write(new_owner);
            self
                .emit(
                    Ownership_transferred { previous_owner: previous_owner, new_owner: new_owner }
                );
        }
    }
}
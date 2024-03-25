#[starknet::contract]
mod erc20 {
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        decimals: u8,
        total_supply: u256,
        balances: LegacyMap::<ContractAddress, u256>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u256,
    }
    
    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252,
    ) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(18);
    }

    
    #[external(v0)]
    fn totalSupply(self: @ContractState) -> u256 {
        self.total_supply.read()
    }

    #[external(v0)]
    fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
        self.balances.read(account)
    }

    #[external(v0)]
    fn allowance(
        self: @ContractState, owner: ContractAddress, spender: ContractAddress
    ) -> u256 {
        self.allowances.read((owner, spender))
    }

    #[external(v0)]
    fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
        let mut sender = get_caller_address();
        self.balances.write(sender, self.balances.read(sender) - amount);
        self.balances.write(recipient, self.balances.read(recipient) + amount);
        //self.emit(Transfer { from: sender, to: recipient, value: amount });
        true
    }

    #[external(v0)]
    fn transfer_from(
        ref self: ContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: u256
    ) -> bool {
        let mut caller = get_caller_address();
        let mut allowance = self.allowances.read((sender, caller));
        self.allowances.write((sender, caller), allowance - amount);
        self.balances.write(sender, self.balances.read(sender) - amount);
        self.balances.write(recipient, self.balances.read(recipient) + amount);
        //self.emit(Transfer { from: sender, to: recipient, value: amount });
        true
    }

    #[external(v0)]
    fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
        let mut caller = get_caller_address();
        self.allowances.write((caller,spender), amount);
        //self.emit(Approval { owner: caller, spender: spender, value: amount});
        true
    }
    

    #[external(v0)]
    fn mint(ref self:ContractState, amount: u256) {
        let mut caller = get_caller_address();
        self.balances.write(caller, self.balances.read(caller) + amount);
        self.total_supply.write(self.total_supply.read() + amount);
        //self.emit(Transfer{ from: Zeroable::zero(), to: caller, value: amount });
    }

    #[external(v0)]
    fn burn(ref self:ContractState, amount: u256) {
        let mut caller = get_caller_address();
        self.balances.write(caller, self.balances.read(caller) - amount);
        self.total_supply.write(self.total_supply.read() - amount);
        //self.emit(Transfer { from: caller, to: Zeroable::zero(), value: amount});
    }
}
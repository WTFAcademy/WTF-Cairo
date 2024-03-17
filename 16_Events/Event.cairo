#[starknet::contract]
mod owner_event{
    // 导入与合约地址相关的库
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    /// 当所有者更改时发出的事件
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ChangeOwner: ChangeOwner,
    }

    #[derive(Drop, starknet::Event)]
    struct ChangeOwner {
        #[key]
        old_owner: ContractAddress, // 旧的所有者地址
        new_owner: ContractAddress  // 新的所有者地址
    }

    // 存储变量
    #[storage]
    struct Storage{
        owner: ContractAddress,  
        balance: felt252,
    }

    // 在部署期间设置所有者地址
    #[constructor]
    fn constructor(ref self: ContractState, balance_: felt252) {
        self.owner.write(get_caller_address());
        self.balance.write(balance_);
    }

    // 读取所有者地址
    #[external(v0)]
    fn read_owner(self: @ContractState) -> ContractAddress{
        self.owner.read()
    }

    #[external(v0)]
    fn balance_read(self: @ContractState) -> felt252 {
        self.balance.read()
    }

    // 更改所有者地址并发出ChangeOwner事件
    // 任何人都可以调用
    #[external(v0)]
    fn change_owner(ref self: ContractState, new_owner: ContractAddress){
        let old_owner = self.owner.read();
        self.owner.write(new_owner);
        // 通过调用事件函数发出事件
        self.emit(ChangeOwner {old_owner: old_owner, new_owner: new_owner});
    }
}

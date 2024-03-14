#[starknet::contract]
mod function_example {

    #[storage]
    struct Storage{
        balance: u128,
    }

    fn add_felt(a: felt252,b: felt252) -> (felt252,u8){
        let c = a + b;
        return (c,1);
    }

    #[external(v0)]
    fn test(self: @ContractState) -> felt252{
        let aa = 2;
        let bb = 3;
        let (c1,_d1) = add_felt(aa,bb);
        let (_c2,_d2) = add_felt(a: aa, b: bb);
        let a = 3;
        let b = 4;
        let (_c, _d) = add_felt(:a,:b);
        return c1;
    }

    fn sum_one(a: felt252,b: felt252) -> felt252{
        //或直接a + b
        let c = a + b;
        c  
    }

    fn sum_two(a: felt252,b: felt252) -> felt252{
        return a + b;
    }

    // view function: can read but not write storage variables.
    #[external(v0)]
    fn read_balance(self: @ContractState) -> u128 {
        return self.balance.read();
    }

    // external: can read and write storage variables.
    #[external(v0)]
    fn write_balance(ref self: ContractState, new_balance: u128) {
        self.balance.write(new_balance);
    }

}

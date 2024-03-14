#[starknet::contract]
mod tuple_example {
    #[storage]
    struct Storage{
        }

    // 元组可用作函数参数和返回值。
    #[abi(embed_v0)]
    fn reverse(pair: (u32, bool)) -> (bool, u32) {
        // 解包：可以使用 `let` 将元组的成员绑定到变量。
        let (integer, boolean) = pair;
        return (boolean, integer);
    }

    #[external(v0)]
    fn tuple(self: @ContractState)->(bool,u32) {
        let (x, y):(u32, bool) = (1, true);
        let (boolean, integer)=reverse((x,y));
        return (boolean, integer);
    }
}

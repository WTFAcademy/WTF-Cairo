#[starknet::contract]
mod Tuple {

    #[storage]
    struct Storage{
    }

    #[abi(embed_v0)]
    fn create_array() -> Array<felt252> {
        // new(): 创建新数组
        let mut arr = ArrayTrait::<felt252>::new();
        // append(): 将元素追加到数组末尾
        arr.append(1);
        arr.append(2);
        arr.append(3);

        // 返回数组
        return arr;
    }   

    #[external(v0)]
    fn pop_front(self: @ContractState) -> (Array<felt252>,felt252,felt252) {
        let mut arr = create_array();
        let x = arr.pop_front().unwrap();
        let y = arr.pop_front().unwrap();
        return (arr, x, y);
    }

    #[external(v0)]
    fn pop_front_consume(self: @ContractState) -> (Array<felt252>,felt252,Array<felt252>,felt252) {
        let mut arr = create_array();
        let mut arr1 = create_array();
        let (arr1, x) = arr1.pop_front_consume().unwrap();
        let (arr, _y) = arr.pop_front_consume().unwrap();
        let (arr, z) = arr.pop_front_consume().unwrap();
        return (arr1,x,arr,z);
    }

    #[external(v0)]
    fn get(self: @ContractState) -> felt252 {
        let mut arr = create_array();
        let x = *arr.get(1).unwrap().unbox();
        return x;
    }

    #[external(v0)]
    fn at(self: @ContractState) -> felt252 {
        let mut arr = create_array();
        let x = *arr.at(3);
        return x;
    }

    #[external(v0)]
    fn len(self: @ContractState) -> (u32,u32) {
        let mut arr = create_array();
        let l1 = arr.len();
        let _x = arr.pop_front().unwrap();
        let l2 = arr.len();
        return (l1,l2);
    }

    #[external(v0)]
    fn is_empty(self: @ContractState) -> (bool,bool) {
        let mut arr = create_array();
        let empty_1 = arr.is_empty();
        let _x1 = arr.pop_front().unwrap();
        let _x2 = arr.pop_front().unwrap();
        let _x3 = arr.pop_front().unwrap();
        let empty_2 = arr.is_empty();
        return (empty_1,empty_2);
    }

    #[external(v0)]
    fn span(self: @ContractState) -> Span<felt252> {
        let mut arr = create_array();
        let my_span = arr.span();
        return my_span;
    }

    #[external(v0)]
    fn clone(self: @ContractState) -> Array<felt252> {
        let mut arr = create_array();
        let mut arr1 = arr.clone();      
        return arr1;
    }   

}

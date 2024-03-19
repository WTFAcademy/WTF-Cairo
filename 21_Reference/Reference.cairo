#[starknet::contract]
mod reference{

    #[storage]
    struct Storage{
    }

    #[derive(Drop,Serde)]
    struct Rectangle {
        height: u64,
        width: u64,
    }

    #[external(v0)]
    fn reference_example(self: @ContractState)-> Rectangle {
        let mut rec = Rectangle { height : 3, width : 10};
        use_reference(ref rec);
        return rec;
    }

    fn use_reference(ref rec: Rectangle) {
        let temp = rec.height;
        rec.height = rec.width;
        rec.width = temp;
    }

    #[external(v0)]
    fn reference_array(self: @ContractState)-> Array<felt252> {
        let mut arr = ArrayTrait::new();
        fill_array(ref arr);
        return arr;
    }

    fn fill_array(ref arr: Array<felt252>) {
        arr.append(11);
        arr.append(22);
        arr.append(33);
    }
}

#[starknet::contract]
mod struct_example {
    #[storage]
    struct Storage{
        var_felt: felt252,
        var_bool: bool,
        var_student: Student,
    }

    #[derive(Copy, Drop, Serde, starknet::Store)]
    struct Student {
        name: felt252,
        score: u128,
    }

     #[external(v0)]
    fn create_struct(self: @ContractState) -> Student{
        let student = Student{ name: '0xAA', score: 100_u128 };
        // let student: Student = Student{ name: '0xAA', score: 100_u128 };
        
        let _student_name = student.name;
        let _student_score = student.score;
        
        let mut student_arr = ArrayTrait::<Student>::new();
        student_arr.append(student);

        return student;
    }

    //struct drop1{
    //    name: u8
    //}

    //#[external(v0)]
    //fn test1(self: @ContractState) {
    //    let _test1 = drop1{ name: 1};
    //}

    #[derive(Copy,Drop)]
    struct Copy1 {
        x: u128
    }

    #[derive(Drop)]
    struct Copy2 {
        x: u128
    }

    #[external(v0)]
    fn test2(self: @ContractState) {
        let copy_test1 = Copy1{ x: 1};
        //let copy_test2 = Copy2{ x: 1};
        foo(copy_test1);
        //foo(copy_test2);
    }

    fn foo(p: Copy1) {}

    #[derive(Clone, Drop)]
    struct clone1 {
        item: felt252
    }

    #[external(v0)]
    fn test3(self: @ContractState) -> felt252 {
        let clone_first = clone1{item: 1};
        let clone_secone = clone_first.clone();
        return clone_secone.item;
    }

    #[derive(PartialEq, Drop)]
    struct partialEq1 {
        item: felt252
    }

    #[external(v0)]
    fn test4(self: @ContractState) -> bool {
        let partialEq_first = partialEq1{item: 2};
        let partialEq_second = partialEq1{item: 2};
        return (partialEq_first == partialEq_second);
    }

    #[derive(Serde, Drop)]
    struct Serde1 {
        item_one: felt252,
        item_two: u8,
    }

    #[external(v0)]
    fn test5(self: @ContractState) -> Array<felt252> {
        let serde_struct = Serde1{item_one: 2, item_two:99};
        let mut serde_array = array![];
        let _serialized = serde_struct.serialize(ref serde_array);
        return serde_array;
    }
}

#[starknet::contract]
mod struct_example {
    use array::ArrayTrait;

    // Declare storage variables with struct
    #[storage]
    struct Storage{
        var_felt: felt252,
        var_bool: bool,
        var_uint: u8,
        }

    // Create custom struct
    #[derive(Copy, Drop, Serde)] // macros: adds more functionality to struct
    struct Student {
        name: felt252,
        score: u128,
    }

    // create and return a Student struct
    #[external(v0)]
    fn create_struct(self: @ContractState) -> Student{
        // create struct
        let student = Student{ name: '0xAA', score: 100_u128 };
        // or
        // let student: Student = Student{ name: '0xAA', score: 100_u128 };
        
        // get values from struct
        let student_name = student.name;
        let student_score = student.score;
        
        // create a array of Student struct
        let mut student_arr = ArrayTrait::<Student>::new();
        student_arr.append(student);

        return student;
    }
}
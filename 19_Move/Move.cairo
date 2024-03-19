#[starknet::contract]
mod ownership_move{
    use array::ArrayTrait;

    #[storage]
    struct Storage{
    }

    #[derive(Drop)]
    struct User {
        name: felt252,
        age: u8,
        school: School
    }

    #[derive(Drop)]
    struct School {
        name: felt252
    }

    #[derive(Copy, Drop)]
    struct Point {
        x: u128,
        y: u128,
    }

    #[derive(Copy)]
    struct Point_Nodrop {
        x: u128,
        y: u128,
    }

    #[derive(Drop)]
    struct Point_Drop {
        x: u128,
        y: u128,
    }

    #[derive(Destruct)]
    struct Dict_Drop {
        mapping: Felt252Dict<felt252>
    }

    // move variable example
    fn move_variable() {
        let x = ArrayTrait::<felt252>::new();  // x becomes the owner of the data
        let y = x;                      // ownership is moved from x to y

        let z = x;              // this will cause a compile error
    }

    // move function example
    fn move_function(){
        let x = ArrayTrait::<felt252>::new();  // x comes into scope

        takes_ownership(x);             // x's value moves into the function
                                        // ... and so is no longer valid here

        // let y = x;           // This would cause a compile error because x is no longer valid

    } // Here, x goes out of scope, but because its value was moved, nothing happens


    fn takes_ownership(some_array: Array<felt252>){ // some_array comes into scope
    } // Here, some_string goes out of scope and `drop` is called, the backing memory is freed

    // copy felt example, integers and felt implemented Copy trait by default
    fn copy_felt(){
        // uint and felt implements Copy trait by default
        let x = 5; // x owns the value 5
        let y = x; // a copy of x is generated and assigned to y
        let z = x; // another copy of x is generated and assigned to z
    }

    // copy struct example, Point implemented Copy trait manually in the contract
    fn copy_struct(){
        // Point struct implements Copy trait
        let p1 = Point { x: 5, y: 10 };
        foo(p1); // a copy of p1 is generated and passed to foo()
        foo(p1); // another copy of p1 is generated and passed to foo()
    }

    fn foo(p: Point) {
        // do something with p
    }

    // no drop example
    fn nodrop_struct(){
        // let p1 = Point_Nodrop { x: 5, y: 10 };
        // error: Variable not dropped.
    }

    // drop example
    fn drop_struct(){
        let p1 = Point_Drop { x: 5, y: 10 };
    }

    fn give_ownership(name: felt252, age: u8, school_name: felt252) -> User {
        User { name: name, age: age, school: School { name: school_name } }
    }

    fn use_User(user: User) {}

    fn school_name(school:School){}

    #[external(v0)]
    fn struct_move(self: @ContractState) -> u8{
        let mut u = give_ownership('WTF', 3, 'WTF Academy');
        //note: variable was previously used here:
        school_name(u.school);
        //error: Variable was previously moved.
        //use_User(u);
        let y = u.age;
        y
    }

    #[external(v0)]
    fn struct_move_second(self: @ContractState){
        let mut u = give_ownership('WTF', 3, 'WTF Academy');
        school_name(u.school);
        u.school = School{
            name:'new WTF'
        };
        use_User(u);
    }

    // destruct 示例
    fn drop_struct(){
        Dict_Drop { mapping: Default::default() };
    }
}

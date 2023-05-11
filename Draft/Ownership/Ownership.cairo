#[contract]
mod OwnershipContract {
    // This struct does not have copy
    #[derive(Drop)]
    struct MyStruct{
        x: u32,
        y: u32,
    }

    #[derive(Copy, Drop)]
    struct MyCopyableStruct{
        x: u32,
        y: u32,
    }

    // Calling the functions via RectGeometryFunctions implementation
    #[view]
    fn with_return() {
        let x = MyStruct{ x: 25_u32, y: 20_u32 };
        let x = my_function(x);
        my_second_function(x);
    }

    // Calling the functions via RectGeometryFunctions implementation
    #[view]
    fn with_copy() {
        let x = MyCopyableStruct{ x: 25_u32, y: 20_u32 };
        my_third_function(x);
        my_fourth_function(x);
    }

    fn my_function( x: MyStruct ) -> MyStruct {
        // Does some stuff
        x
    }

    fn my_second_function( x: MyStruct ) {
        // Does something
    }

    fn my_third_function( x: MyCopyableStruct ){
        // Does some stuff
    }

    fn my_fourth_function( x: MyCopyableStruct ) {
        // Does something
    }
}

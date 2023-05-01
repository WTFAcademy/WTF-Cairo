#[contract]
mod Data_Types{
    //////////////////
    // Arrays
    //////////////////
    use array::ArrayTrait;
    use array::SpanTrait;
    use option::OptionTrait;
    use box::BoxTrait;

    #[view]
    fn create_array() -> Array<felt252> {
        // Creating an empty array
        let mut a = ArrayTrait::new(); 

        // Appending values to the array
        a.append(0);
        a.append(1);
        a.append(1);

        // Removing the first element
        a.pop_front().unwrap();

        // Retrieving the element
        let elem_one = a.at(0_usize);
        let elem_two = a.get(1_usize).unwrap().unbox();

        // Length of the array
        let length = a.len();

        // Checking if array is empty or not
        if (a.is_empty()) {
            // array is empty
        } else {
            // array not empty
        }

        // Creating a span 
        let my_span = a.span();

        // Returning the array
        a
    }

    //////////////////
    // Structs
    //////////////////
    #[derive(Copy, Drop)]
    struct Collection{
        lucky_number: u8,
        is_true: bool,
        unlucky_number: u16,
    }

    #[view]
    fn main_struct() {
        let new_collection = Collection{lucky_number: 7_u8, is_true: true, unlucky_number: 420_u16};
    }

    //////////////////
    // Constants
    //////////////////
    const LUCKY_NUMBER: u8 = 7_u8;

    #[view]
    fn main_constant() -> u8 {
        LUCKY_NUMBER
    }

    //////////////////
    // Tuples
    //////////////////
    #[view]
    fn main_tuples() {
        let tuple: (u8, bool, u16) = (7_u8, true, 420_u16);

        let (lucky_number, is_true, unlucky_number) = tuple;
    }
}
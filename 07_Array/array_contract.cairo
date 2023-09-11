#[starknet::contract]
mod array_example {
    use array::ArrayTrait;
    use array::SpanTrait;
    use option::OptionTrait;
    use box::BoxTrait;

    #[storage]
    struct Storage{
        }

    #[external(v0)]
    fn create_array(self: @ContractState) -> Array<felt252> {
        // new(): create new array
        let mut arr = ArrayTrait::new();
        // You can also specify the type of the array
        // let mut arr_felt = ArrayTrait::<felt252>::new();

        // append(): append an element to the end of an array
        arr.append(1);
        arr.append(2);
        arr.append(3);

        // pop_front(): removes the first element from the array 
        let pop_element = arr.pop_front().unwrap();

        // at(): get element at a particular index
        let elem_one = *arr.at(0);

        // get(): get element at a particular index, returns an Option type.
        // Need import OptionTrait and BoxTrait
        let elem_two = *arr.get(1).unwrap().unbox();

        // len(): length of the array
        let length = arr.len();

        // is_empty(): checks if an array is empty or not and returns a boolean value
        let empty_arr = arr.is_empty();

        // span(): A span is a struct containing a snapshot of an array. 
        // Need import SpanTrait
        let my_span = arr.span();

        return arr;
    }
}
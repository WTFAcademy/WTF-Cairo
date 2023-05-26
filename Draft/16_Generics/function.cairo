use array::ArrayTrait;

// The PartialOrd trait implements comparison operations for T
// The Copy trait implements copy operation from @T to T
// The Drop trait makes type T droppable
fn smallest_element<T, impl TPartialOrd: PartialOrd<T>, impl TCopy: Copy<T>, impl TDrop: Drop<T>>(list: @Array<T>) -> T {
    let mut smallest = *list[0_usize];
    let mut index = 1_usize;
    loop {
        if index >= list.len(){
            break smallest;
        }
        if *list[index] < smallest {
            smallest = *list[index];
        }
        index = index + 1;
    }
}

fn main()  {
    let mut list = ArrayTrait::new();
    list.append(5_u8);
    list.append(3_u8);
    list.append(10_u8);

    let s = smallest_element(@list);
}
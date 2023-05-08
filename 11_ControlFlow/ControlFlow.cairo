use debug::PrintTrait;

fn main() {
    // ********* IF-ELSE *************//
    let number = 6_u8;

    if number < 10_u8 {
        'number is less than 10'.print();
    } else {
        'number is not less than 10'.print();
    }

    // ********* LOOPS *************//
    let counter = 0_u8;

    loop {
        if counter <= 10_u8 {
            break();
        } 

        counter.print();
    }
}
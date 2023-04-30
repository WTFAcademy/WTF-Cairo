// To compile a Cairo program, we use: 

//cargo run --bin cairo-run -- /path/to/file.cairo

// Calculates fib...
fn fib(a: felt252, b: felt252, n: felt252) -> felt252 {
    match n {
        0 => a,
        _ => fib(b, a + b, n - 1),
    }
}

fn main()-> felt252{

    let a = 3;
    let b = 5;
    let n = 8;
     
    fib(a, b, n) 
}
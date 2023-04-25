
//using ref
fn main() -> felt {
  let mut n = 1;
  b(ref n);
  n
}

fn b (ref n: felt){
  n = 1;
}


//using constant 
const num: felt = 15;
fn main() -> felt {
  NUM
}


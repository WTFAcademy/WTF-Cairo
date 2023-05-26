use debug::PrintTrait;

struct Bill<T> {
    totalCost: T,
}

impl BillDrop<T, impl TDrop: Drop<T>> of Drop<Bill<T>>;

fn main() {
    let w1 = Bill { totalCost: 5_u8 };
    let w2 = Bill { totalCost: 5888_u128 };
    w1.totalCost.print();
    w2.totalCost.print();
}
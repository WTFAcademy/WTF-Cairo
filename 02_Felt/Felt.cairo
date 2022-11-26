%lang starknet
from starkware.cairo.common.math import unsigned_div_rem

@view
func int() -> (res: felt) {
    return (res=7828582);
}

@view
func bytes() -> (res: felt) {
    return (res=0x777466);
}

@view
func shortString() -> (res: felt) {
    return (res='wtf');
}

@view
func operations() -> (add: felt, minus: felt, multiply: felt, divide: felt, divide1: felt, recover: felt) {
    let x = 10;
    let y = 5;
    let add = x + y;
    let minus = x - y;
    let multiply = x * y;
    let divide = x/y;
    // note the division of felt is different from integers.
    let divide1 = 3/2;
    let recover = divide1*2;
    return (add, minus, multiply, divide, divide1, recover);
}
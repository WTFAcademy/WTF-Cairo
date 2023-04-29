%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

// 定义余额变量，类型：felt.
@storage_var
func balance() -> (res: felt) {
}

// 设置余额balance.
@external
func set_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(amount: felt) {
    balance.write(amount);
    return ();
}

// 读取余额balance.
@view
func read_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() -> (amount: felt) {
    let (res) = balance.read();
    return (amount=res);
}

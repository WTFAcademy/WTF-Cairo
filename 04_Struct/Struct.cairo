%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

// 定义结构体
struct User {
    name: felt,
    age: felt,
}

// 定义状态变量 new_user，类型：User.
@storage_var
func new_user() -> (user: User){
}

// 设置 user 信息
@external
func set_user{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(user: User) {
    new_user.write(user);
    return ();
}

// 读取 user 信息
@view
func read_user{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() -> (user: User) {
    let (res) = new_user.read();
    return (user=res);
}

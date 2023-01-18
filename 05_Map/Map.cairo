%lang starknet

struct User {
    name: felt,
    age: felt,
}

@storage_var
func get_weight_height(user: User) -> (weight_height: (felt, felt)) {
}

@storage_var
func balance(address : felt) -> (amount : felt){
}

@external
func set_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(address: felt, amount: felt) {
    balance.write(address, amount);
    return ();
}

@view
func read_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(address: felt) -> (amount: felt){
    let (res) = balance.read(address = address);
    return (amount=res);
}
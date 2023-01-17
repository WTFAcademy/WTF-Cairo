%lang starknet

@storage_var
func balance(address : felt) -> (amount : felt){
}

@external
func set_balanec{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(address: felt, amount: felt) {
    balance.write(address, amount);
    return ();
}

@external
func read_balanec{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(address: felt) -> (amount: felt){
    let (res) = balance.read(address = address);
    return (amount=res);
}
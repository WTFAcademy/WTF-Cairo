#[contract]
mod StorageWrite {
    use starknet::storage_write_syscall;
   
    
    #[external]
    fn write_to_storage(){
        let storage_address = storage_base_address_from_felt252(3534535754756246375475423547453);
        storage_write_syscall(0, storage_address, 'Hello');
    }
}
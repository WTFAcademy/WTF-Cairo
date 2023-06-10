#[contract]
mod StorageRead {
    use starknet::storage_read_syscall;
    use starknet::storage_write_syscall;
    
    #[external]
    fn read()-> felt252{
        //write to storage
       let storage_address = storage_base_address_from_felt252(3534535754756246375475423547453);
        storage_write_syscall(0, storage_address, 'Hello');

       //read from storage
        storage_read_syscall(0, storage_address).unwrap_syscall();
    }
}
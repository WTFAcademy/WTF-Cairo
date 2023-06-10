#[contract]
mod ReplaceClass {
    use starknet::replace_class_syscall;
    use starknet::ClassHash;
    
    #[external]
    fn replace_class_syscall(class_hash: ClassHash) {
        replace_class_syscall(class_hash).unwrap_syscall()
    }
}
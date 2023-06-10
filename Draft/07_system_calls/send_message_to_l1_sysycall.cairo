#[contract]
mod L1Messenger{
    use starknet::send_message_to_l1_syscall;
   
    
    #[external]
    fn send_message_to_l1(to_address: felt252,payload: Span<felt252>){
        send_message_to_l1_syscall(to_address, payload);
    }
}
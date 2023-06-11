#[contract]
mod EventEmitter {
    use starknet::emit_event_syscall;
    use array::SpanTrait;
    
    #[external]
    fn emit(){
        //Array of keys
        let keys = ArrayTrait::new();
        keys.append('transfer');
        keys.append('deposit');
        
         //Array of values
        let values = ArrayTrait::new();
        values.append(1);
        values.append(2);

        emit_event_syscall(keys.span(), values.span());

    }
}
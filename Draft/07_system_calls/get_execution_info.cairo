mod ExecutionInfo {
    use starknet::get_execution_info_syscall;
    use box::BoxTrait;
    use starknet::info::ExecutionInfo;
    
    
    #[external]
    fn get_execution_info(){
        let exe_info: ExecutionInfo =get_execution_info_syscall().unwrap_syscall();

        let contract_address= exe_info.unbox().contract_address;

        let caller = exe_info.unbox().caller_address;

        let block_info = exe_info.unbox().block_info;

        let tx_info = exe_info.unbox().tx_info;

        let block_timestamp =exe_info.unbox().block_timestamp;

        let block_number =exe_info.unbox().block_number;
    }
    
}

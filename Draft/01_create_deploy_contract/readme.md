# WTF Starknet. Chapter 1: How to set up a new Cairo project and deploy it

Starknet is a permissionless network that leverages the power of zk-STARKs technology for scalability, privacy, and security. 

To communicate with the Starknet Network, we use Cairo Programming Language. 

Cairo is a powerful Turing-complete programming language initially developed by Starkware and is currently open-source. It has been explicitly designed to enable efficient computation and proof generation for STARK-based systems. 

## Create a contract

To create a new cairo project, we need to create a new directory where we put our `.cairo` file.

```shell
    mkdir first_program
    cd first_program
    touch main.cairo
```

Then you can use the following contract:

```shell 
    #[contract]
    mod HelloStarknet {

        struct Storage {
            sum : felt252
        }

        #[event]
        fn success_sum(new_balance: felt252) {}

        #[external]
        fn sum_balances(balance_one : felt252, balance_two : felt252) {
            let new_balance = balance_one + balance_two;
            sum::write(new_balance);
            success_sum(new_balance);

        }

        #[internal]
        fn get_balance()-> felt252{
            sum::read()
        }
    }
```
Now let's install the tools necessary to build, deploy, and interact with Cairo smart contracts on the Starknet network. 

## Install and configure development enviroment.

In the root folder, first install [python 3.9](https://www.python.org/downloads/release/python-390/) using the official page and rust using this command:

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

After install python and rust, follow the next steps: 

```shell
git clone https://github.com/starkware-libs/cairo/
cd cairo
git checkout 9c190561ce1e8323665857f1a77082925c817b4c
cargo build --all --release
```
At this point you have Cairo installed in your project. 

Go back to the root folder of your project and set up a python virtual environment.

```shell
python3.9 -m venv ~/cairo_venv_v11
source ~/cairo_venv_v11/bin/activate
```

Install Cairo-lang:

```shell
pip3 install ecdsa fastecdsa sympy
pip3 install cairo-lang
```

Check that you have it installed correctly

```shell
starknet --version
```

## Creating an account 

To declare and deploy you contract, you need to create an account. First, we need to configure some environment variables:

```shell
export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
```

To create an account use:

```shell
starknet new_account --account WTF_Academy
```

After this, you should get your contract address. Use this address and send some funds from another account, use starkscan to monitor the transfer and once it has passed "pending", proceed to deploy your account 

```shell
starknet deploy_account --account WTF_Academy
```

Again, use starkscan to monitor the transfer and once it has passed "pending", proceed to compile, declare and deploy your contract.

## Compile, declare and deploy a contract.

To compile your contract, go to the cairo folder:

```shell
cd cairo
cargo run --bin starknet-compile -- ../main.cairo ../main.json --replace-ids
```

You have compiled your contract from Cairo to Sierra.

To declare your contract, go back to the root folder and then try to declare:

```shell
cd ..
starknet declare --contract main.json --account WTF_Academy
```

You should receive your newly declared class hash. 

To deploy your contract, use the class hash that we receive when declare the contract:

```shell
starknet deploy --class_hash <class_hash> --account WTF_Academy
```

Monitor your transaction using starkscan and voyager. Once your transaction is `accepted_on_l2`... Congratulations! You have deployed your first contract with Cairo 1!

## Conclusion

In this tutorial, we create an account that is necessary to declare and deploy our cairo contrancts in the future. 

## References.

1. [Starknet -  Edu](https://github.com/starknet-edu/deploy-cairo1-demo)
2. [Starknet book](https://book.starknet.io/chapter_1/environment_setup.html)
3. [Cairo repository](https://github.com/starkware-libs/cairo/)





---
title: 31. ERC20
tags:
  - cairo
  - starknet
  - wtfacademy
  - ERC20
---

# WTF Cairo极简教程: 31. ERC711

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这节中，我们将会讲一下非同质化代币（NFT），并介绍一下ERC20标准，并基于它发行一款NFT。

## NFT

当我们谈论`BTC`、`ETH`或`STRK`等加密数字货币时，通常指的是同质化代币。这意味着无论是第一枚还是第一千枚代币，它们之间没有区别，都是可相互替换的，并且可以被分割成任意大小。

然而，与同质化代币截然不同的是非同质化代币（Non-Fungible Token，NFT）。`NFT`的关键特征在于每一个代币都拥有独一无二的标识，使其不可替换。此外，`NFT`是不可分割的，其最小单位是1。这意味着，每一个`NFT`都是唯一的存在，就像人类每个个体都有自己独特的特质和个性一样。

## ERC165

通过[ERC165标准](https://eips.ethereum.org/EIPS/eip-165)，智能合约可以声明它支持的接口，供其他合约检查。简单的说，ERC165就是检查一个智能合约是不是支持了`ERC721`，`ERC1155`的接口。

`IERC165`接口合约只声明了一个`supportsInterface`函数，输入要查询的`interfaceId`接口id，若合约实现了该接口id，则返回`true`：

```rust
#[starknet::interface]
trait IERC165<TState> {
    fn supports_interface(self: @TState, interface_id: felt252) -> bool;
}
```

## IERC721

`IERC721`是`ERC721`标准的接口合约，规定了`ERC721`要实现的基本函数。它利用`tokenId`来表示特定的非同质化代币，授权或转账都要明确`tokenId`；而`ERC20`只需要明确转账的数额即可。

```rust
#[starknet::interface]
trait IERC721<TState> {
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn owner_of(self: @TState, token_id: u256) -> ContractAddress;
    fn safe_transfer_from(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    );
    fn transfer_from(ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u256);
    fn approve(ref self: TState, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TState, operator: ContractAddress, approved: bool);
    fn get_approved(self: @TState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
}
```

- `balance_of`：返回某地址的NFT持有量`balance`。
- `owner_of`：返回某`tokenId`的主人`owner`。
- `safe_transfer_from`：安全转账（如果接收方是合约地址，会要求实现`IERC721Receiver`接口）。参数为转出地址`from`，接收地址`to`和`tokenId`。
- `transfer_from`：普通转账，参数为转出地址`from`，接收地址`to`和`tokenId`。
- `approve`：授权另一个地址使用你的NFT。参数为被授权地址`approve`和`tokenId`。
- `set_approval_for_all`：将自己持有的该系列NFT批量授权给某个地址`operator`。
- `get_approved`：查询`tokenId`被批准给了哪个地址。
- `is_approved_for_all`：查询某地址的NFT是否批量授权给了另一个`operator`地址。

## IERC721Receiver

如果一个合约没有实现`ERC721`的相关函数，转入的`NFT`就进了黑洞，永远转不出来了。为了防止误转账，`ERC721`实现了`safe_transfer_from()`安全转账函数，目标合约必须实现了`IERC721Receiver`接口才能接收`ERC721`代币，不然会`revert`。`IERC721Receiver`接口只包含一个`on_erc721_received()`函数。

```rust
#[starknet::interface]
trait IERC721Receiver<TState> {
    fn on_erc721_received(
        self: @TState,
        operator: ContractAddress,
        from: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    ) -> felt252;
}
```

## IERC721Metadata
`IERC721Metadata`是`ERC721`的拓展接口，实现了3个查询`metadata`元数据的常用函数：

```rust
#[starknet::interface]
trait IERC721Metadata<TState> {
    fn name(self: @TState) -> felt252;
    fn symbol(self: @TState) -> felt252;
    fn token_uri(self: @TState, token_id: felt252) -> Array<felt252>;
}
```

- `name()`：返回代币名称。
- `symbol()`：返回代币代号。
- `token_uri()`：通过`tokenId`查询`metadata`的链接`url`，`ERC721`特有的函数。

## ERC721主合约
`ERC721`主合约实现了`IERC721`，`IERC165`和`IERC721Metadata`定义的所有功能，包含`4`个状态变量和`17`个函数。实现都比较简单：

```rust
use starknet::ContractAddress;

// 接口对应的hash
const IERC721_ID: felt252 = 0x33eb2f84c309543403fd69f0d0f363781ef06ef6faeb0131ff16ea3175bd943;
const IERC721_METADATA_ID: felt252 = 0xabbcd595a567dce909050a1038e055daccb3c42af06f0add544fa90ee91f25;
const IERC721_RECEIVER_ID: felt252 = 0x3a0dff5f70d80458ad14ae37bb182a728e3c8cdda0402a5daa86620bdf910bc;

#[starknet::interface]
trait IERC165<TState> {
    fn supports_interface(self: @TState, interface_id: felt252) -> bool;
}

#[starknet::interface]
trait IERC721<TState> {
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn owner_of(self: @TState, token_id: u256) -> ContractAddress;
    fn safe_transfer_from(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    );
    fn transfer_from(ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u256);
    fn approve(ref self: TState, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TState, operator: ContractAddress, approved: bool);
    fn get_approved(self: @TState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
}

#[starknet::interface]
trait IERC721Metadata<TState> {
    fn name(self: @TState) -> felt252;
    fn symbol(self: @TState) -> felt252;
    fn token_uri(self: @TState, token_id: felt252) -> Array<felt252>;
}

#[starknet::interface]
trait IERC721Receiver<TState> {
    fn on_erc721_received(
        self: @TState,
        operator: ContractAddress,
        from: ContractAddress,
        token_id: u256,
        data: Span<felt252>
    ) -> felt252;
}

#[starknet::contract]
mod ERC721 {

    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use super::IERC721_RECEIVER_ID;
    use super::IERC721_ID;
    use super::IERC721_METADATA_ID;

    #[storage]
    struct Storage{
        name: felt252,
        symbol: felt252,
        owners: LegacyMap<u256, ContractAddress>,
        balances: LegacyMap<ContractAddress, u256>,
        token_approvals: LegacyMap<u256, ContractAddress>,
        operator_approvals: LegacyMap<(ContractAddress, ContractAddress), bool>,
        token_uri: LegacyMap<u256, felt252>,
        total_supply: u256,
    }

    #[event]
    #[derive(Drop, PartialEq, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
        ApprovalForAll: ApprovalForAll,
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        #[key]
        token_id: u256
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        approved: ContractAddress,
        #[key]
        token_id: u256
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    struct ApprovalForAll {
        #[key]
        owner: ContractAddress,
        #[key]
        operator: ContractAddress,
        approved: bool
    }

    mod Errors {
        const INVALID_TOKEN_ID: felt252 = 'ERC721: invalid token ID';
        const INVALID_ACCOUNT: felt252 = 'ERC721: invalid account';
        const UNAUTHORIZED: felt252 = 'ERC721: unauthorized caller';
        const APPROVAL_TO_OWNER: felt252 = 'ERC721: approval to owner';
        const SELF_APPROVAL: felt252 = 'ERC721: self approval';
        const INVALID_RECEIVER: felt252 = 'ERC721: invalid receiver';
        const ALREADY_MINTED: felt252 = 'ERC721: token already minted';
        const WRONG_SENDER: felt252 = 'ERC721: wrong sender';
        const SAFE_MINT_FAILED: felt252 = 'ERC721: safe mint failed';
        const SAFE_TRANSFER_FAILED: felt252 = 'ERC721: safe transfer failed';
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252
    ){
        self.name.write(name);
        self.symbol.write(symbol);
    }

    #[abi(embed_v0)]
    impl ERC165Impl of super::IERC165<ContractState>{
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool{
            (interface_id == IERC721_ID) |
            (interface_id == IERC721_METADATA_ID) 
        }
    }

    #[abi(embed_v0)]
    impl ERC721Impl of super::IERC721<ContractState> {
        
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            assert(!account.is_zero(), Errors::INVALID_ACCOUNT);
            self.balances.read(account)
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            let owner = self.owners.read(token_id);
            assert(!owner.is_zero(),Errors::INVALID_TOKEN_ID);
            return owner;
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            assert(!self.owners.read(token_id).is_zero(), Errors::INVALID_TOKEN_ID);
            self.token_approvals.read(token_id)
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self.operator_approvals.read((owner, operator))
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self.owners.read(token_id);
            let caller = get_caller_address();
            assert(
                owner == caller || ERC721Impl::is_approved_for_all(@self, owner, caller),
                Errors::UNAUTHORIZED
            );
            self._approve(to, token_id);
        }

        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            let owner = get_caller_address();
            assert(owner != operator, Errors::SELF_APPROVAL);
            self.operator_approvals.write((owner, operator), approved);
            self.emit(ApprovalForAll { owner, operator, approved });
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            let owner = self.owners.read(token_id);
            let spender = get_caller_address();
            assert(
                self._is_approved_or_owner(owner, spender, token_id), Errors::UNAUTHORIZED
            );
            self._transfer(owner, from, to, token_id);
        }

        fn safe_transfer_from(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            let owner = self.owners.read(token_id);
            assert(
                self._is_approved_or_owner(owner, get_caller_address(), token_id), Errors::UNAUTHORIZED
            );
            self._safe_transfer(owner, from, to, token_id, data);
        }

    }

    #[abi(embed_v0)]
    impl ERC721MetadataImpl of super::IERC721Metadata<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }

        //无聊猿BAYC的baseURI为ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/ 
        fn token_uri(self: @ContractState, token_id: felt252) -> Array<felt252> {
            let mut uri = ArrayTrait::<felt252>::new();
            uri.append('ipfs://QmeSjSinHpPnmXm');
            uri.append('spMjwiXyN6zS4E9zcc');
            uri.append('ariGR3jxcaWtq/');
            uri.append(token_id);
            uri
        }
    }


    #[starknet::interface]
trait IERC721Metadata<TState> {
    fn name(self: @TState) -> ByteArray;
    fn symbol(self: @TState) -> ByteArray;
    fn token_uri(self: @TState, token_id: u256) -> ByteArray;
}

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self.owners.read(token_id);
            assert(owner != to, Errors::APPROVAL_TO_OWNER);

            self.token_approvals.write(token_id, to);
            self.emit(Approval { owner, approved: to, token_id });
        }

        fn _transfer(
            ref self: ContractState, owner: ContractAddress, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            assert(!to.is_zero(), Errors::INVALID_RECEIVER);
            assert(from == owner, Errors::WRONG_SENDER);
            self.token_approvals.write(token_id, Zeroable::zero());
            self.balances.write(from, self.balances.read(from) - 1);
            self.balances.write(to, self.balances.read(to) + 1);
            self.owners.write(token_id, to);
            self.emit(Transfer { from, to, token_id });
        }

        fn _is_approved_or_owner(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress, token_id: u256
        ) -> bool {
            owner == spender || self.token_approvals.read(token_id) == spender || self.operator_approvals.read((owner, spender))
        }

        fn _safe_transfer(
            ref self: ContractState,
            owner: ContractAddress,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            self._transfer(owner, from, to, token_id);
            assert(
                InternalImpl::_check_on_erc721_received(from, to, token_id, data), Errors::SAFE_TRANSFER_FAILED
            );
        }

        //在实际开发中，请按照OpenZeppenlin的格式来
        fn _check_on_erc721_received(
            from: ContractAddress, to: ContractAddress, token_id: u256, data: Span<felt252>
        ) -> bool {
            return true;
        }

        fn _burn(ref self: ContractState, token_id: u256) {
            let owner = self.owners.read(token_id);

            self.token_approvals.write(token_id, Zeroable::zero());

            self.balances.write(owner, self.balances.read(owner) - 1);
            self.owners.write(token_id, Zeroable::zero());

            self.emit(Transfer { from: owner, to: Zeroable::zero(), token_id });
        }
    }

    #[external(v0)]
    fn mint(ref self: ContractState, to: ContractAddress){
        let token_id = self.total_supply.read() + 1;
        assert(!to.is_zero(), Errors::INVALID_RECEIVER);
        assert(!self.owners.read(token_id).is_zero(), Errors::ALREADY_MINTED);
        self.balances.write(to, self.balances.read(to) + 1);
        self.owners.write(token_id, to);
        self.total_supply.write(self.total_supply.read() + 1);
        self.emit(Transfer { from: Zeroable::zero(), to, token_id });
    }
}
```

## 部署合约
有了`ERC721`标准后，在`ETH`链上发行NFT变得非常简单。现在，我们发行属于我们的NFT。

![](./img/31-1.png)

## 总结

这一讲，我介绍了`ERC721`标准、接口及其实现。

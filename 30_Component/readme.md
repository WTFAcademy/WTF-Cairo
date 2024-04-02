---
title: 30. 组件
tags:
  - cairo
  - starknet
  - wtfacademy
  - component
---

# WTF Cairo极简教程: 30. 组件

我最近在学`cairo-lang`，巩固一下细节，也写一个`WTF Cairo极简教程`，供小白们使用。教程基于`cairo 2.2.0`版本。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)｜[@WTFAcademy_](https://twitter.com/WTFAcademy_)

WTF Academy 社群：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在 github: [github.com/WTFAcademy/WTF-Cairo](https://github.com/WTFAcademy/WTF-Cairo)

---

在这节中，我们学习组件的定义与实现，如何在合约中使用组件，如何在组件中使用组件，以及组件的内部机制。

## 组件

在合约开发中，有些业务逻辑和内存变量经常需要复用，如果我们把这一部分内容单独封装成一个组件，将会使得合约开发具有可组合性，开发者只需要实现合约特有的功能逻辑即可，Cairo提供组件（Component）功能来帮助实现这一目标。

组件（Component）与合约（Contract）非常类似，也是一个具有存储变量、事件和逻辑函数的模块（module），区别在于它不能独立部署，而需要嵌入到合约中才能部署。正如之前所说，组件封装了可复用的合约功能，而不需要开发者重复实现。比如所有权组件，甚至更复杂的 ERC20 token 也可以封装成组件。

## 创建组件

与创建合约不同，我们需要为组件模块标注 `#[starknet::component]` 属性（atrribute），以此告诉编译器这是一个组件模块。

创建组件与创建合约类似，首先需要在接口（interface）中声明包含一组可复用逻辑函数的签名(signature)。同样的，编译器看到 `#[starknet::interface]` 之后会自动为其生成调度器（Dispatcher）及调度器相关的 trait 。然后我们可以创建组件模块，包括定义存储变量、事件，实现之前接口定义公共函数以及其他接口（通常是匿名接口）的私有函数。

以下总结了创建组件与合约之间的不同之处：

1. 组件模块标注 `#[starknet::component]` 属性（atrribute），以此告诉编译器这是一个组件模块；而合约模块标注 `#[starknet::contract]` 。
2. 组件中**实现公共函数的 impl 块**需要标注 `#[embeddable_as(name)])` ；而合约中实现公共函数的 impl 块需要标注 `#[abi(embed_v0)]` 或者需要公开的独立函数（standalone function）的实现需要标注 `#[external(v0)]`。
   
   注意，这里设置的 name 就是之后在合约中使用组件时所使用的组件名字。

3. 组件中**所有函数（包括公共和私有）的 impl 块的实现名**不仅需要标注合约状态泛型 `TContractState` ，而且它需要满足 `hasComponent` trait，这个可以用之前所学的 trait bound（接口约束）实现，即 `+hasComponent<TContracState>`，同时，**公共函数的 impl 块**给所实现的 trait 传入的合约状态泛型需要变为 `ComponentState<TContractState>` ，**私有函数的 impl 块**给所实现的 trait 传入的合约状态泛型为 `TContractState`；而合约所有函数的 impl 块的实现名都不需要标注合约状态泛型，只需要给公共函数所实现的泛型 trait 传入合约状态 `ContractState` 即可，私有函数什么都不需要传入。

    比如：
    - 实现合约时：
        ```cairo
        // 公共函数
        #[abi[embed_v0]]
        impl ERC20Impl of super::IERC20<ContractState> { ... };

        // 私有函数
        #[generate_trait]
        impl InternalImpl of InternalTrait { ... };
        ```
    - 实现组件时
        ```
        // 公共函数
        #[embeddable_as(ERC20)]
        impl ERC20Impl of super::IERC20<Component<TContractState>> { ... }

        // 私有函数
        #[generate_trait]
        imple InternalImpl of InternalTrait<TContractState> { ... };
        ```
    

下面是一个所有权组件的创建代码，使用该组件的合约将会具备所有权特性，可以指定合约所有人、转移所有权和放弃所有权。

```cairo
use starknet::ContractAddress;

#[starknet::interface]
trait IOwnable<TContractState> {
    fn owner(self: @TContractState) -> ContractAddress;
    fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
    fn renounce_ownership(ref self: TContractState);
}


#[starknet::component]
mod ownable_component {
    use starknet::{ ContractAddress, get_caller_address };
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        owner: ContractAddress,
    }

    mod Errors {
        pub const NOT_OWNER: felt252 = 'Caller is not the owner';
        pub const NOT_PENDING_OWNER: felt252 = 'Caller is not the pending owner';
        pub const ZERO_ADDRESS_CALLER: felt252 = 'Caller is the zero address';
        pub const ZERO_ADDRESS_OWNER: felt252 = 'New owner is the zero address';
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Ownership_transferred: Ownership_transferred,
    }

    #[derive(Drop, starknet::Event)]
    struct Ownership_transferred {
        #[key]
        previous_owner: ContractAddress,
        #[key]
        new_owner: ContractAddress,
    }

    #[embeddable_as(Ownable)]
    impl OwnableImpl<TContractState, +HasComponent<TContractState>> of super::IOwnable<ComponentState<TContractState>> {
        fn owner(self: @ComponentState<TContractState>) -> ContractAddress {
            self.owner.read()
        }

        fn transfer_ownership(ref self: ComponentState<TContractState>, new_owner: ContractAddress) {
            assert(!new_owner.is_zero(), Errors::ZERO_ADDRESS_OWNER);
            self.assert_only_owner();
            self._transfer_ownership(new_owner);
        }
        fn renounce_ownership(ref self: ComponentState<TContractState>) {
            self.assert_only_owner();
            self._transfer_ownership(Zero::zero());
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>, owner: ContractAddress) {
            self._transfer_ownership(owner);
        }

        fn assert_only_owner(self: @ComponentState<TContractState>) {
            let owner: ContractAddress = self.owner.read();
            let caller: ContractAddress = get_caller_address();
            assert(!caller.is_zero(), Errors::ZERO_ADDRESS_CALLER);
            assert(caller == owner, Errors::NOT_OWNER);
        }

        fn _transfer_ownership(
            ref self: ComponentState<TContractState>, new_owner: ContractAddress
        ) {
            let previous_owner: ContractAddress = self.owner.read();
            self.owner.write(new_owner);
            self
                .emit(
                    Ownership_transferred { previous_owner: previous_owner, new_owner: new_owner }
                );
        }
    }
}
```

通过上述转换，我们就可以把合约中的可复用功能封装成组件。

## 在合约中使用组件

当组件封装完毕后，我们需要在合约中使用它，我们需要做以下几步：

1. 使用 `component!()` 宏声明（declare）组件。这个宏需要我们指定组件所在路径 `path` ，合约中指向组件存储状态的存储变量名 `storage` （相当于给组件中定义的存储状态取别名），最后是组件中定义的事件名 `event` ；
2. 把上述组件存储变量和事件加入到当前合约的存储变量和事件中，并且存储变量必须标注为 #[substorage(v0)]；
3. 通过把实际的合约状态 `ContractState` 替换掉组件中的合约泛型 `TContractState` 来把组件中的功能逻辑实现添加的合约中。注意这里必须要为新的逻辑功能实现取一个实现别名（impl alias），并且标注为 #[abi(embed_v0)]。

还是上述 `Ownable` 组件的例子，让我们在一个合约中使用它：

```cairo
#[starknet::contract]
mod OwnableCounter {
    use src::component::ownable_component;

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;

    impl OwnableInternalImpl = ownable_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        counter: u128,
        #[substorage(v0)]
        ownable: ownable_component::Storage
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnableEvent: ownable_component::Event
    }


    #[abi(embed_v0)]
    fn foo(ref self: ContractState) {
        self.ownable.assert_only_owner();
        self.counter.write(self.counter.read() + 1);
    }
}

```

至此，组件已经与合约无缝衔接在一起了。

## 深入理解组件

那么有人可能问：创建组件和创建合约的底层机制是什么？为什么引入了一个 `ComponentState`？

为了深入理解其中的原油，我们首先得理解 `embeddable impls` ，译为可嵌入的实现。 `#[starknet::interface]` 标注的接口的实现就是可嵌入的，编译器会把它们标注为 `#[starknet::embeddable]`，这些实现可以嵌入到任何合约中，为外界提供合约的入口点（entry points），即公共函数。这些实现过后的函数当然也会添加到合约的ABI中。

了解了嵌入机制后，我们再来看看创建 component 时所使用的语法：

```cairo
    #[embeddable_as(Ownable)]
    impl OwnableImpl<
        TContractState, +HasComponent<TContractState>
    > of super::IOwnable<ComponentState<TContractState>> { ... }
```

关键点在于：

- `OwnableImpl` 这个实现它要求合约实现了 `HasComponent<TContractState>` trait。这个 trait 是合约在使用组件时使用 `component!()` 宏自动生成的。

    当合约使用这个组件时，编译器会自动把`OwnableImpl` 实现中函数签名的参数由 `self: ComponentState<TContractState>` 替换为 `self: TContractState` 。能够这样做正是因为合约实现了 `HasComponent<TContractState>` trait，这个接口中定义了一系列泛型合约如何获取组件逻辑的方法：

    ```cairo
    // generated per component
    trait HasComponent<TContractState> {
        fn get_component(self: @TContractState) -> @ComponentState<TContractState>;
        fn get_component_mut(ref self: TContractState) -> ComponentState<TContractState>;
        fn get_contract(self: @ComponentState<TContractState>) -> @TContractState;
        fn get_contract_mut(ref self: ComponentState<TContractState>) -> TContractState;
        fn emit<S, impl IntoImp: traits::Into<S, Event>>(ref self: ComponentState<TContractState>, event: S);
    }
    ```

    如此一来，当合约中使用了某一组件，合约就可以通过上述方式获取组件中定义的功能逻辑，为其所用。

    可以看到这个接口中不仅定义了合约如何获取组件实现中的功能逻辑（get_component, get_component_mut），而且还定义了组件如何获取合约的信息的函数，这就涉及的到组件依赖（Component Dependencies），将下一节再介绍。

- `Ownable` 由 `#[embeddable_as(...)]` 属性标注，其实和 `#[starknet::embeddable]` 类似，都只能标注给 `#[starknet::interface]` 接口的实现，并且此实现可以嵌入到任意合约中。不同之处是， `#[embeddable_as(...)]` 属性还可以发挥**组件实现嵌入到合约**的作用。

## 组件依赖

之前已经说过，组件只能嵌入到合约中才能部署，但是**这不意味我们不能在一个组件中使用另一个组件**。

考虑一个组件 `OwnerCount` ，它的作用是为所有者创建一个计数器，只能所有者才能使它递增。鉴于最小化实现原则，我们不想在新组件中重新实现 `Ownable` 所有功能，而是在基于 `Ownable` 组件开发。

实现如下：

```cairo
use starknet::ContractAddress;

#[starknet::interface]
trait IOwnableCounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increment(ref self: TContractState);
    fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
}

#[starknet::component]
mod OwnableCounterComponent {
    use src::owner::{ownable_component, ownable_component::InternalImpl};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        value: u32
    }

    #[embeddable_as(OwnableCounterImpl)]
    impl OwnableCounter<
        TContractState,
        +HasComponent<TContractState>,
        +Drop<TContractState>,
        impl Owner: ownable_component::HasComponent<TContractState>
    > of super::IOwnableCounter<ComponentState<TContractState>> {
        fn get_counter(self: @ComponentState<TContractState>) -> u32 {
            self.value.read()
        }

        fn increment(ref self: ComponentState<TContractState>) {
            let ownable_comp = get_dep_component!(@self, Owner);
            ownable_comp.assert_only_owner();
            self.value.write(self.value.read() + 1);
        }

        fn transfer_ownership(
            ref self: ComponentState<TContractState>, new_owner: ContractAddress
        ) {
            let mut ownable_comp = get_dep_component_mut!(ref self, Owner);
            ownable_comp._transfer_ownership(new_owner);
        }
    }
}
```

在一个组件中使用另一个组件其实是较为容易，只需要在实现中再添加一个 trait bound ，即 `impl Owner: ownable_component::HasComponent<TContractState>`，这表示在新组件的实现中要求对合约实现了 `ownable_component` 组件，然后利用之前看到的两个函数，新组件可以从合约中获取另一个组件的存储状态信息，从而达到预期效果。

既然，我们依赖 `ownable` 组件实现了一个新的组件，那么如何使用这个新组件呢？根据是否改变 `ownable` 组件的存储状态，我们有两种方案。

- 如果不改变其存储状态，可以使用 `get_dep_component!()` 宏；
- 如果改变其存储状态，使用 `get_dep_component_mut!()` 宏。

这两个宏的参数都一样，第一个参数是组件本身 `self`，根据是否改变状态选择 reference 还是 snapshot；第二个参数就是欲访问的组件实现。

## 总结

综上，我们学习了组件的基本使用方法，如何在合约中使用组件，如何在组件中使用组件依赖，以及组件的内部机制。当进行（特别是大型）项目开发，避不可免需要使用到社区提供的组件，或者自定义组件，这可以帮助我们更多关注项目本身的逻辑细节，从而降低开发难度。

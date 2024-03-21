#[starknet::contract]
mod trait_impl{

    #[storage]
    struct Storage{
    }

    // Example struct
    #[derive(Copy, Drop)]
    struct Rectangle{
        h: u64,
        w: u64,
    }

    trait RectGeometry {
        fn boundary(self: Rectangle) -> u64;
        fn area(self: Rectangle) -> u64;
        fn change_h(ref self: Rectangle, value: u64);
    }

    // Implementation for the trait for type `Rectangle`
    impl RectGeometryImpl of RectGeometry {
        fn boundary(self: Rectangle) -> u64 {
            2_u64 * (self.h + self.w)
        }

        fn area(self: Rectangle) -> u64 {
            self.h * self.w
        }

        fn change_h(ref self: Rectangle, value: u64) {
            self.h = value;
        }
    }

    #[abi(per_item)]
    #[generate_trait]
    impl ImplicitInterfaceContract of trait_impl {
        #[external(v0)]
        fn get_value(self: @ContractState) -> u32 {
            3_u32
        }
    }

    #[external(v0)]
    fn call_impl(self: @ContractState) -> (u64, u64) {
        let rect = Rectangle { h: 5_u64, w: 7_u64 };
        (RectGeometryImpl::boundary(rect), RectGeometryImpl::area(rect))
    }

    #[external(v0)]
    fn change_height_first(self: @ContractState) -> u64 {
        let mut rect = Rectangle { h: 5_u64, w: 7_u64 };
        RectGeometryImpl::change_h(ref rect,6);
        rect.h
    }

    #[external(v0)]
    fn call_object(self: @ContractState) -> (u64, u64) {
        let rect = Rectangle { h: 5_u64, w: 7_u64 };
        (rect.boundary(), rect.area())
    }

    #[external(v0)]
    fn change_height_second(self: @ContractState) -> u64 {
        let mut rect = Rectangle { h: 5_u64, w: 7_u64 };
        rect.change_h(6_u64);
        rect.h
    }
}

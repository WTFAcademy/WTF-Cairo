#[contract]
mod variables {
    // Our blueprint, the trait
    trait GeometryFunctions<T> {
        fn boundary(self: T) -> u64;
        fn area(self: T) -> u64;
    }

    // Example struct
    #[derive(Copy, Drop)]
    struct Rectangle{
        h: u64,
        w: u64,
    }

    // Implementation for the trait for type `Rectangle`
    impl RectGeometryFunctions of GeometryFunctions::<Rectangle> {
        fn boundary(self: Rectangle) -> u64 {
            2_u64 * (self.h + self.w)
        }
        fn area(self: Rectangle) -> u64 {
            self.h * self.w
        }
    }

    // Calling the functions via RectGeometryFunctions implementation
    #[view]
    fn call_impl() -> (u64, u64) {
        let rect = Rectangle { h: 5_u64, w: 7_u64 };
        (RectGeometryFunctions::boundary(rect), RectGeometryFunctions::area(rect))
    }

    // Calling the functions via the created object, thanks to self keyword
    #[view]
    fn call_object() -> (u64, u64) {
        let rect = Rectangle { h: 5_u64, w: 7_u64 };
        (rect.boundary(), rect.area())
    }
}

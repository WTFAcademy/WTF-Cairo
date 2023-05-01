# Contract directives and Imports

As you became more advanced in Cairo Programming you will write more robust programs and you will need to organize your code. 

By grouping related functionality and separating code with distinct features, you’ll clarify where to find code that implements a particular feature and where to go to change how a feature works.

These features, sometimes collectively referred to as the *module system*, include:

- Packages: A Scarb feature that lets you build, test, and share crates
- Crates: A tree of modules that corresponds to a single compilation unit. It has a root directory, and a root module defined at the file lib.cairo under this directory.
- Modules and use: Let you control the organization and scope of items.
- Paths: A way of naming an item, such as a struct, function, or module

Let's discuss how they interact, and explain how to use them to manage scope. 

## Packages and crates 

A crate is the smallest amount of code that the Cairo compiler considers at a time. Crates can contain modules, and the modules may be defined in other files that get compiled with the crate. 

A cairo package is a bundle of one or more crates with a Scarb.toml file that describes how to build those crates. This enables the splitting of code into smaller, reusable parts and facilitates more structured dependency management.

To create a new Cairo package using the scarb command-line tool, run the following command:

```
scarb new my_crate
```

This command will generate a new package directory named my_crate with the following structure:

```
my_crate/
├── Scarb.toml
└── src
    └── lib.cairo
```

- src/ is the main directory where all the Cairo source files for the package will be stored.
- lib.cairo is the default root module of the crate, which is also the main entry point of the package. By default, it is empty.
- Scarb.toml is the package manifest file, which contains metadata and configuration options for the package, such as dependencies, package name, version, and authors. You can find documentation about it on the [scarb reference](https://docs.swmansion.com/scarb/docs/reference/manifest).

## Modules

After we create our scarb project, we can start to organize modules and other parts of the module system, namely paths that allow you to name items and the `use` keyword that brings a path into scope.

When compiling a crate, the compiler first looks in the crate root file (src/lib.cairo) for code to compile.

In the crate root file, you can declare new modules using the following sintax:

````
    // crate root file (lib.cairo)
    mod module_name {
        // code defining the module goes here
    }

````

or adding just a declaration in the crate root file and a new source file

````
    // crate root file (lib.cairo)
    mod module_name;
````

````
    // module file (src/module_name.cairo)
    mod module_name{
        // code defining the module goes here
    }
````

In any file other than the crate root, you can declare submodules. For example in the source file `src/module_name.cairo` we declare a submodule in the following ways:

We can add the declaration in the `src/module_name.cairo`

````
    // module file (src/module_name.cairo)
    mod submodule_name{
        // code defining the submodule goes here
    }
````

Or as follows:
````
    // module file (src/module_name.cairo)
    mod submodule_name;
````

````
    // submodule file (src/module_name/module_name.cairo)
    mod submodule_name{
        // code defining the module goes here
    }
````

Once a module is part of your crate, you can refer to code in that module from anywhere else in that same crate, using the path to the code. For example, to declare a new type of module would be found at:

````
    my_crate::module_name::submodule_name::new_type;
````

Within a scope, the `use` keyword creates shortcuts to items to reduce repetition of long paths. In any scope that can refer to `my_crate::module_name::submodule_name::new_type;` , you can create a shortcut with `use my_crate::module_name::submodule_name::new_type;` and from then on you only need to write `new_type` to make use of that type in the scope.

Modules let us organize code within a crate for readability and easy reuse.

To show Cairo where to find an item in a module tree, we use a path in the same way we use a path when navigating a filesystem. To call a function, we need to know its path. A path can take two forms:

1. An absolute path is the full path starting from a crate root. The absolute path begins with the crate name.
2. A relative path starts from the current module.

Both absolute and relative paths are followed by one or more identifiers separated by double colons (::).

Having to write out the paths to call functions can feel inconvenient and repetitive. Fortunately, there’s a way to simplify this process: we can create a shortcut to a path with the `use` keyword once, and then use the shorter name everywhere else in the scope.

The exception to `use` keyword is if we’re bringing two items with the same name into scope, because Cairo doesn’t allow that. 

There’s a solution to the problem of bringing two types of the same name into the same scope with `use`; after the path, we can specify `as` and a new local name, or alias, for the type. For example:

````
    use my_crate::module_name::submodule_name::new_type as my_name

````

Cairo 1, also have the option of starting relative paths with `super` keyword. Using `super` you access a parent's module easily. 

Choosing whether to use a super or not is a decision you’ll make based on your project, and depends on whether you’re more likely to move item definition code separately from or together with the code that uses the item.

In this chapter, we learned about the techniques to separate our code and how Cairo has a number of features that allow you to manage your code’s organization. 
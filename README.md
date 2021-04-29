# Inject
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/illescasDaniel/Inject-swift/blob/master/LICENSE)

Easy dependency injection for swift, compatible with structs and classes.

## Basic example

1. Define your **protocol**
2. Define a **class** (or struct) implementing it
3. Create a **static variable of the dependency resolver**
4. **Add the dependency** using the dependency resolver
5. **Inject it** using `@Inject`

```swift
// 1
protocol UserRepository {
    func add(user: String) -> Int
}

// 2
class DefaultUserRepository: UserRepository {
    func add(user: String) -> Int {
        return 1
    }
}

// "3"
class DependencyInjection {
    static let dependencies: DependencyResolver = DefaultDependencyResolver()
}

// 4. somewhere (like in your main / AppDelegate)
DependencyInjection.dependencies.add(
    UserRepository.self,
    using: DefaultUserRepository() // autoclosure
)

// 5
struct InjectedDependenciesExample {

    @Inject(resolver: DependencyInjection.dependencies)
    private var userRepository: UserRepository

    init() {}

    init(
        userRepository: UserRepository?
    ) {
        // if you pass a non-nil `userRepository`, it will asign it to your local `self.userRepository`; else, it will use the injected dependency (don't forget the "$")
        self.$userRepository = userRepository
    }
}

/* OK examples: */

let example1 = InjectedDependenciesExample()

// explicitly acknowledge that it will use the injected value
let example2 = InjectedDependenciesExample(userRepository: nil)

// explicitly use another value instead of the default/injected one
let example3 = InjectedDependenciesExample(userRepository: OtherUserRepository())
```

### **TIP**: declare a default constructor extension for `@Inject` that uses your dependency injection
```swift
extension Inject {
    init() {
        self.init(resolver: DependencyInjection.dependencies)
    }
}

// Result :) niiice

struct InjectedDependenciesExample {

    @Inject()
    private var userRepository: UserRepository

    init() {}

    init(
        userRepository: UserRepository?
    ) {
        self.$userRepository = userRepository
    }
}
```

## Singleton example

```swift
// 1
class FakeUserDefaultsManager {

    init() {}

    var username: String {
        get { "Daniel" }
        set { /*...*/ }
    }
    // ...
    
    // no need for a static variable here, since we'll use the resolver
}

// "2"
class DependencyInjection {
    static let singletons: SingletonResolver = DefaultSingletonResolver()
}

// 3. somewhere (like in your main / UIApplicationMain)
// you can also use a protocol and a value as with the previous example
DependencyInjection.singletons.add(
    FakeUserDefaultsManager() /* autoclosure */
)

extension InjectSingleton {
    init() {
        self.init(resolver: DependencyInjection.singletons)
    }
}

struct InjectedDependenciesExample2 {

    @InjectSingleton()
    private var userDefaults: FakeUserDefaultsManager

    // If you don't want to use `init` you can just use
    @AutoWiredSingleton()
    private var userDefaults: FakeUserDefaultsManager

    init() {}

    init(
        userDefaults: FakeUserDefaultsManager?
    ) {
        self.$userDefaults = userDefaults
    }
}
```

## FAQ
> 1 - Do I need to use `@Inject` or `@AutoWired`

No, you can just do `DependencyInjection.dependencies.resolve(YourTypeHere.self)` and it will give you the instance.

> 2 - How can I use it with structs? Should I?

Good question, you can if you want.
**Using structs in your normal dependencies should be OK** (unless you use some shared code in that struct or something), because the resolver will just store a function that returns a value.

But you should not use structs directly in your singleton dependencies (because you want to use the same values across your program) unless wrapped by a class (like the `Box<T>` class provided in this library) or if added like this:
`DependencyInjection.singletons.addBox(...)` . When you later use `@InjectSingleton` you should declare a local variable like `Box<MyStructSingleton>`, this will behave as a class because of the `Box` type (which encloses a type inside a class).

You can also use `AutoWiredBoxSingleton` for these case:
```swift
@AutoWiredBoxSingleton()
var userDefaultsStruct: FakeUserDefaultsManagerStruct
// FakeUserDefaultsManagerStruct is a struct, and `userDefaultsStruct` will return that value, but if you do any modification it behaves like a normal class...
```

About using it if is not a singleton I would say you shouln't have any problems if that struct doesn't mutate. If it does, consider wrapping the value inside the `Box` type.

> 3 - TL;DR too many steps...

Actually... you only need to create the dependency injection class and the Inject extensions once, so after that you just need to use `@Inject` and remember to add the dependencies before using it.

> 4 - If I don't use, for any reason, the injected value or a singleton, would that still create an instance?

No, until you use the value, it is not retrieved from the dependencies container.

Same happends with singletons. The 'singleton resolver' stores the singleton **as a function** until is first called, then it stores its reference value.

> 4 - Do I need a library like this for simple dependencies on my small app?

Probably not, but you might consider using it if your app grows or if you just like the way of handling dependencies.

**I wrote about it in my article at medium**: https://itnext.io/9aa1015d8342

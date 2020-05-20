@propertyWrapper
public struct Inject<T> {
	
	@Lazy
	private var value: T
	
	public init(resolver: Resolver) {
		assert(resolver.isAdded(T.self))
		$value = resolver.resolve
	}
	
	public var wrappedValue: T {
		get { value }
		set { value = newValue }
	}
	
	public var projectedValue: T? {
		get { value }
		set {
			if let validValue = newValue {
				value = validValue
			}
		}
	}
}

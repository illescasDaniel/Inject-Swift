@propertyWrapper
public struct Inject<T> {
	
	@Lazy
	private var value: T
	
	public init(resolver: DependencyResolver) {
		assert(resolver.isAdded(T.self), "No dependency for: \(T.self)")
		self._value = Lazy<T>(builder: resolver.resolve)
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

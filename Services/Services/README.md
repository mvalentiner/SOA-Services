# Swift Service Oriented Architecture

Service Oriented Architecture (SOA) is a software pattern that consolidates functionality and business logic implementation into services within the application. By building around services, we can move business logic implementation out of our UIViewControllers thereby reducing their complexity.
Utilizing dependency injection, we can configure and instantiate our services independent of their point use. By injecting services into our UIViewControllers, we allievate them from needing to know the details of how to access a service, how to construct a service, and how to satisfy a service's dependencies.

### What is a Service?
In SOA, a service is anything that inherits from the `SOAService` protocol. It can be thought of, but not restricted to, as a concrete component with an abstract functional interface. For example,
`protocol AuthenticationService : SOAService {
	func register(withUsername: String, andPassword: String)
	func login(withUsername: String, andPassword: String)
}`

This defines an `AuthenticationService` interface, but says nothing about an underlying implementation.  By building around protocols, it is easy to provide alternate implementations or to mock up a service for testing:

`internal class LocalAuthenticationServiceImplementation : SharingService { ... }`

`internal class RemoteServiceImplementation : SharingService { ... }`

`internal class TestServiceImplementation : SharingService { ... }`
 
 The power of the protocol based interface is that the code using the service, typically, a `UIViewController`, doesn't change.

### The `ServiceRegistry`
A key component in SOA is the ServiceRegistry. It is a central registry the application code can access to obtain services.  We configure and register our services, typically, at application startup: 
`class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AuthenticationServiceImplementation.register()
		...
	}
	...
}`

`register()` is a convenience function provided by the service implementaiton:

`internal class AuthenticationServiceImplementation : AuthenticationService {
	static func register() {
		ServiceRegistry.add(service: AuthenticationServiceImplementation())
	}
	...
}`

By extending the ServiceRegistry, we can provide a simple, natural means for accessing a service:
`extension ServiceRegistryImplementation {
	var authenticationService : AuthenticationService {
		get {
			return serviceWith(name: AuthenticationService.serviceName) as! AuthenticationService	// Intentional force unwrapping
		}
	}
}`

After that, we access the service via the ServiceRegistry:
`let authenticationService = ServiceRegistry.authenticationService`

and inject services into our UIViewControllers:
`AuthenticationViewController(authenticationService)`

### SOALazyService
SOA has a way to lazily instantiate a service:
	`SOALazyService(serviceName: sharingServiceName) { SharingServiceImplementation() }`

`SOALazyService()` is a class that is also an `SOAService` that takes a service name and a closure that instantiates and returns the service. Instantiation of the service is defered until the service is first accessed. At that time, the closure is invoked, the service is instantiated, and returned.  Note: as an implementation detail, all services are managed as LazyServices even if they are not Lazy.

The SOA ServiceRegistry is the ServiceLocator Pattern: ``https://en.wikipedia.org/wiki/Service_locator_pattern``

## SOAService.swift
SOAService.swift has all the code to define services, register services, access services, and the implementation of the ServiceRegistry.

### ServiceRegistry
For coding convenience, ServiceRegistry is defined as a global app-wide object:
	`let ServiceRegistry = ServiceRegistryImplementation()`
There are pros and cons to this that I will discuss later. Even though, it is not coded as singleton, it acts on a static Dictionary, so the actual registry data structure is a singleton:
	`private static var serviceDictionary : [String : SOALazyService] = [:]`
The functional interface consists of functions to add a service to the registry:
	`internal func add(service: SOAService)`
and to access a service from the registry:
	`internal func serviceWith(name: String) -> SOAService`

Services can define convenience functions that add syntactic sugar and make registering and accessing services less error prone as we saw with the `AuthenticationServiceImplementation` example above.  For a service that has no dependencies and initializer takes no parameters (`init()`), the default register function is implemented:
	`extension SOAService {
		// Default implementation for a service to register itself with the ServiceRegistry.
		internal func register() {
			ServiceRegistry.add(service: self)
		}
	}`

To define a service, a struct or class need simply inherit from the `SOAService` protocol and satisfy the protocol requirement of defining a unique service name:
	`protocol SOAService {
		// Every SOAService has a unique name.
		var serviceName : String { get }
		...
	}`
As mentioned, a default `register()` is provided, but more complex services will need to define their own. For example,
	`internal static func register(with service: SOAService) {
		ServiceRegistry.add(service: MoreComplexService(with: service))
	}`
As mentioned, we can register our service as a lazy service:
	`internal static func register() {
		ServiceRegistry.add(service: SOALazyService(serviceName: sharingServiceName) { MyLazyServiceImplementation() })
	}`

### ServiceTemplate.swift is boilerplate code for starting a SOAService.

## The Services Demo App

### SharingService.swift Example
An example service that wraps iOS's UIActivityViewCotroller.

### ServiceRegistry.sharingService
A convenience function for accessing the SharingService with the Registry.
	`extension ServiceRegistryImplementation {
		var sharingService : SharingService {
			get {
				return serviceWith(name: sharingServiceName) as! SharingService
			}
		}
	}`

### struct SharingServiceImplementation : SharingService
	`SharingServiceImplementation` is the production implementation of the SharingService. Here it is registered as a Lazy Service to demonstrate that process:
	`internal class SharingServiceImplementation : SharingService {
		internal static func register() {
			ServiceRegistry.add(service: SOALazyService(serviceName: sharingServiceName) { SharingServiceImplementation() })
		}
	}`

### protocol SharingService
The interface to the SharingService.

`protocol SharingService : SOAService {
	func share(_ content : Any, withActivityItems activityItems : [Any], presentingController : UIViewController)
}`

### extension SharingService
The default implementation of the SharingService.

`extension SharingService {
	var serviceName : String { get { return sharingServiceName } }
`
`	internal func share(_ sharable : Any, withActivityItems activityItems : [Any] = [], presentingController : UIViewController) {
		showActivityViewController(with: [sharable] + activityItems, presentingController: presentingController)
	}
`
`	private func showActivityViewController(with activityItems: [Any], presentingController : UIViewController) {
		let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		var excludedActivityTypes = [
			UIActivity.ActivityType.postToWeibo,
			UIActivity.ActivityType.print,
			UIActivity.ActivityType.assignToContact,
			UIActivity.ActivityType.saveToCameraRoll,
			UIActivity.ActivityType.addToReadingList,
			UIActivity.ActivityType.postToVimeo,
			UIActivity.ActivityType.postToTencentWeibo,
			UIActivity.ActivityType.airDrop,
			UIActivity.ActivityType.openInIBooks
		]
		if #available(iOS 11.0, *) {
			excludedActivityTypes = excludedActivityTypes + [UIActivity.ActivityType.markupAsPDF]
		}
		activityViewController.excludedActivityTypes = excludedActivityTypes
		presentingController.present(activityViewController, animated: true)
    }
}`

### struct SharingServiceImplementation : SharingService
The production implementation of the SharingService.
`internal class SharingServiceImplementation : SharingService {
	internal static func register() {
		ServiceRegistry.add(service: SOALazyService(serviceName: sharingServiceName) { SharingServiceImplementation() })
	}
}
`

### struct TestSharingServiceImplementation : SharingService
An example mockable test implementation of the SharingService.
`internal class TestSharingServiceImplementation : SharingService {
	internal static func register() {
		TestSharingServiceImplementation().register()
	}
}`

### AppDelegate.didFinishLaunchingWithOptions
Contains code to create and register Services:
`	SharingServiceImplementation.register()
`

### MainViewController is "injected" witrh the service
`class MainViewController: UIViewController {
	...
	// "Inject" service here.
	let sharingService = ServiceRegistry.sharingService
	...
`

### MainViewController.handleShareTextButtonTap
`	@IBAction func handleShareTextButtonTap(_ sender: Any) {
		guard let textToShare = textField.text else {
			return
		}
		self.sharingService.share(textToShare, presentingController: self)
	}
`

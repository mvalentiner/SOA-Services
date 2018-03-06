# Heliotropix Services

This a a dependency injection coding pattern I've been playing with to implement a Services Layer in iOS apps.  It is a work in progress.
The pattern requires Services be instatiated and added to the ServiceRegistry, typically at start up, for example in AppDelegate.didFinishLaunchingWithOptions.
Services are accessed by name, typically, by an extension to the ServiceRegistry, for example, ServiceRegistry.getSharingService().

## ServiceRegistry.swift

This is the core of the Services Layer.  It consists of a Service protocol all services must implement and a ServiceRegistry for registering and retrieving Services.
It started out bigger but has been reduced to surprisingly little code.  I attribute that to Swift.

## SharingService.swift

An example service that wraps iOS's UIActivitityViewCotroller.

### ServiceRegistry.getSharingService()

A convenience function for registering the SharingService with the Registry.

### protocol SharingService

The interface to the SharingService.

### extension SharingService

The default implementation of the SharingService.

### struct SharingServiceImplementation : SharingService

The production implementation of the SharingService.

### struct TestSharingServiceImplementation : SharingService

An example mockable test implementation of the SharingService.

## AppDelegate.didFinishLaunchingWithOptions

Contains code to create and register Services:
			SharingServiceImplementation.register()

## MainViewController.handleShareTextButtonTap

Contains code to access and use the SharingService:
		let sharingService = ServiceRegistry().getSharingService()
		let sharableText = SharableText(textToShare)
		sharingService.share(sharableText, withActivityItems: [], presentingController: self)


## Discussion

To date, this is just a simple example.
It doesn't show injection of services into a more complex service.  An example, might be:
	let networkService = NetworkServiceImplementation.register()
	AuthenticationServiceImplementation.register(networkService: networkService)

It doesn't address the common problem of circularly dependent services.  For example, what if the NetworkService requires the AuthenticationService.

	
	

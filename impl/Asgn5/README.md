# Bluetooth App

Bluetooth App is an iPhone app that allows two iPhones to send photos to each other via the Bluetooth LE protocol.

## Design

Bluetooth App uses the [`CoreBluetooth` framework](https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html) in the iOS SDK. It has two view controllers, `BTATransferViewController` and `BTAImageViewController`, that provide the two views for the app. The other two classes are the `BTACentralManagerDelegate` and `BTAPeripheralManagerDelegate`, which provide delegate methods for `CoreBluetooth` functionality.

### A Note on `CoreBluetooth`

`CoreBluetooth` uses the concepts of a "central" and a "peripheral" for device-to-device communication.

A peripheral is a Bluetooth LE device that advertises information about services that it provides. In Bluetooth App, the `BTATransferViewController` creates an instance of a `CBPeripheralManager` so that it can advertise that it has a photo to share once a user selects one to send.

A central searches for peripherals that are advertising services and connects with them in order to receive data from said services. In Bluetooth App, the `BTATransferViewController` creates an instance of a `CBCentralManager` so that it can search for peripherals with the designated service, connect to one, and receive the photo being advertised.

### View Controllers

The `BTATransferViewController` provides the main view for the app. This view consists of two buttons, "Send Photo" and "Receive Photo", that allow the user to use the app as either a central or a peripheral.

The `BTAImageViewController` is a very simple view controller that just displays the image that has been received from a peripheral.

### Delegate Classes

The `BTACentralManagerDelegate` and `BTAPeripheralManagerDelegate` classes provide delegate methods for `CoreBluetooth` to function properly, such as when a central has found a peripheral with the correct advertised service, or when a peripheral has received a read request for its advertised service data. These methods could all be included in the `BTATransferViewController` class, but for the sake of modularity and lean view controllers, they have been extracted out into their own classes.

## Usage

1. Open *Bluetooth App.xcworkspace* in Xcode.
2. Press ⌘R to run the app or ⌘U to run the unit test suite.

// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol.

public final class AmplifyModels: AmplifyModelRegistration {
    public let version: String = "46394a250077297297569ab305a4cb90"

    public func registerModels(registry _: ModelRegistry.Type) {
        ModelRegistry.register(modelType: Todo.self)
    }
}

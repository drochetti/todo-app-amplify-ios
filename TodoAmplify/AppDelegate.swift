import Amplify
import AmplifyPlugins
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let isConfigured = configureAmplify()

        if isConfigured {
            loadSampleData()
        }

        return isConfigured
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: Amplify Configuration

    private func configureAmplify() -> Bool {
        do {
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
            return true
        } catch {
            print("Error configuring Amplify!")
            print(error)
            return false
        }
    }

    private func loadSampleData() {
        let todo = Todo(name: "Sample Todo #1",
                        done: false,
                        priority: .high)
        Amplify.DataStore.save(todo) {
            switch $0 {
            case .success:
                print("Todo saved successfully!")
            case let .failure(error):
                print("Error saving a Todo")
                print(error)
            }
        }
    }
}

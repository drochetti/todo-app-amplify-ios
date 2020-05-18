## Todo App using Amplify for iOS

This is a simple Todo application showcasing the new Amplify Framework for iOS with SwiftUI. The main piece of Amplify is `Amplify.DataStore` for an offline-first storage mechanism with cloud syncing capabilities.

### Prerequisites

- Cocoapods: https://cocoapods.org
- NodeJS >= 10.x: https://nodejs.org/en/download/package-manager/#macos (or via https://github.com/nvm-sh/nvm)
- Amplify CLI: https://docs.amplify.aws/cli/start/install

### Setup

1. The project is using Cocoapods, so the first step is to install the dependencies:
  ```
  pod install --repo-update
  ```
2. Open the Xcode workspace `TodoAmplify.xcworkspace` or use `xed .` from your Terminal.

### Syncing with the cloud

In order to sync the data with the cloud, you will need to provision an AppSync API. That can be done either through the Amplify Tools Xcode integration or through the Amplify CLI.

#### Option 1: Using Amplify Tools

1. Edit the file `amplifytools.xcconfig` and change `push` to `true`
2. Rebuild the project (e.g. `CMD+B`)

#### Option 2: Using Amplify CLI

```
amplify add api
```

### Detailed docs

https://docs.amplify.aws/lib/getting-started/setup/q/platform/ios

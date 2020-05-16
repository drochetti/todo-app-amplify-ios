import Amplify
import Combine
import Foundation

struct DataLoader {
    let publisher = PassthroughSubject<Todo, Never>()

    init() {
        _ = publisher
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink(receiveValue: createTodo(_:))
    }

    func generateTodos(count: Int) {
        let batchId = Date().timeIntervalSince1970
        (0 ..< count).forEach { i in
            let todo = Todo(
                name: "Auto-generated Todo \(batchId) - \(i)",
                done: .random(),
                priority: .normal,
                description: """
                This Todo was auto-generated for data integrity testing purposes.
                The system should be able to keep the local and remote data in sync.
                """
            )
            publisher.send(todo)
        }
    }

    func createTodo(_ todo: Todo) {
        DispatchQueue.global().async {
            Amplify.DataStore.save(todo) {
                switch $0 {
                case .success:
                    print("Generated Todo saved successfully!")
                case let .failure(error):
                    print("====> Error saving generated Todo!")
                    print(error)
                }
            }
        }
    }
}

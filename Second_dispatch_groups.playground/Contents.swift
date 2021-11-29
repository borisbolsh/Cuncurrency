import UIKit


// group of tasks
let group = DispatchGroup()

someQueue.async(group: group) { ... your work ...
}
someQueue.async(group: group) { ... more work ....
}
someOtherQueue.async(group: group) { ... other work ...
}

group.notify(queue: DispatchQueue.main) { [weak self] in
 self?.textLabel.text = "All jobs have completed"
}


//wait time

let group = DispatchGroup()

someQueue.async(group: group) {
    ...
}
someQueue.async(group: group) {
    ...
}
someOtherQueue.async(group: group) {
    ...
}

if group.wait(timeout: .now() + 60) == .timedOut {
    print("The jobs didn’t finish in 60 seconds")
    }

// Note: Remember, this blocks the current thread; never ever call wait on the main queue.







// With Tread sleep

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)
queue.async(group: group) {
 print("Start job 1")
 Thread.sleep(until: Date().addingTimeInterval(10))
 print("End job 1")
}
queue.async(group: group) {
 print("Start job 2")
 Thread.sleep(until: Date().addingTimeInterval(2))
 print("End job 2")
}

if group.wait(timeout: .now() + 5) == .timedOut {
    print("I got tired of waiting")
} else {
    print("All the jobs have completed")
}

/// Start job 1
/// Start job 2
/// End job 2
/// I got tired of waiting
/// End job 1


// defer { group.leave() }
func myAsyncAdd(
    lhs: Int,
    rhs: Int,
    completion: @escaping (Int) -> Void) {
        // Lots of cool code here
        completion(lhs + rhs)
    }
func myAsyncAddForGroups(
    group: DispatchGroup,
    lhs: Int,
    rhs: Int,
    completion: @escaping (Int) -> Void) {
        group.enter()
        myAsyncAdd(first: first, second: second) { result in
            defer { group.leave() }
            completion(result)
        }
    }

import UIKit

// Race conditions



// Thread barrier

private let threadSafeCountQueue = DispatchQueue(
    label: "...",
    attributes: .concurrent
)
private var _count = 0
public var count: Int {
    get {
        return threadSafeCountQueue.sync {
            return _count
        }
    }
    set {
        threadSafeCountQueue.async(flags: .barrier) { [unowned self]
            in
            self._count = newValue
        }
    }
}




import Foundation
import PlaygroundSupport

// Tell the playground to continue running, even after it thinks execution has ended.
// You need to do this when working with background tasks.
PlaygroundPage.current.needsIndefiniteExecution = true

let high = DispatchQueue.global(qos: .userInteractive)
let medium = DispatchQueue.global(qos: .userInitiated)
let low = DispatchQueue.global(qos: .background)

let semaphore = DispatchSemaphore(value: 1)

high.async {
    // Wait 2 seconds just to be sure all the other tasks have enqueued
    Thread.sleep(forTimeInterval: 2)
    semaphore.wait()
    defer { semaphore.signal() }

    print("High priority task is now running")
}

for i in 1 ... 10 {
    medium.async {
        let waitTime = Double(exactly: arc4random_uniform(7))!
        print("Running medium task \(i)")
        Thread.sleep(forTimeInterval: waitTime)
    }
}

low.async {
    semaphore.wait()
    defer { semaphore.signal() }

    print("Running long, lowest priority task")
    Thread.sleep(forTimeInterval: 5)
}


/// Running medium task 1
/// Running medium task 3
/// Running medium task 7
/// Running medium task 4
/// Running medium task 2
/// Running medium task 5
/// Running medium task 6
/// Running medium task 8
/// Running medium task 10
/// Running medium task 9
/// Running long, lowest priority task
/// High priority task is now running

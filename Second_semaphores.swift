import UIKit
import PlaygroundSupport

/*:
 Tell the playground to continue running, even after it thinks execution has ended.
 You need to do this when working with background tasks.
 */

PlaygroundPage.current.needsIndefiniteExecution = true

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInteractive)
let semaphore = DispatchSemaphore(value: 2)

let base = "https://picsum.photos/id/"
let ids = [1001, 1002, 1003, 1004, 1004, 1006, 1007, 1008, 1009]
let end = "/100/100/"

var images: [UIImage] = []

for id in ids {
  guard let url = URL(string: "\(base)\(id)\(end)") else { continue }
  
  semaphore.wait()
  group.enter()
  
  let task = URLSession.shared.dataTask(with: url) { data, _, error in
    defer {
      group.leave()
      semaphore.signal()
    }
    
    if error == nil,
      let data = data,
      let image = UIImage(data: data) {
      images.append(image)
    }
  }
  
  task.resume()
}

group.notify(queue: queue) {
  images[0]
  
  //: Make sure to tell the playground you're done so it stops.
  PlaygroundPage.current.finishExecution()
}

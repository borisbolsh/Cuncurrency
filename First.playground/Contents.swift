import UIKit

// Create your own concurrent dispatch queue
let queue = DispatchQueue(
    label: label,
    qos: .userInitiated,
    attributes: .concurrent)




// URLsession

private func downloadWithUrlSession(at indexPath: IndexPath) {
    URLSession.shared.dataTask(with: urls[indexPath.item]) {
        [weak self] data, response, error in
        guard let self = self,
              let data = data,
              let image = UIImage(data: data) else {
                  return
              }
        DispatchQueue.main.async {
            if let cell = self.collectionView
                .cellForItem(at: indexPath) as? PhotoCell {
                cell.display(image: image)
            }
        }
    }.resume()
}



// Work item

let queue = DispatchQueue(label: "xyz")
let workItem = DispatchWorkItem {
 print("The block of code ran!")
}
queue.async(execute: workItem)



// DispatchWorkItem class also provides a notify(queue:execute:)

let queue = DispatchQueue(label: "xyz")
let backgroundWorkItem = DispatchWorkItem { }
let updateUIWorkItem = DispatchWorkItem { }
backgroundWorkItem.notify(queue: DispatchQueue.main, execute: updateUIWorkItem)

queue.async(execute: backgroundWorkItem)

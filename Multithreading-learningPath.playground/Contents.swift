import UIKit
// Thread
//Operation
//GCD


//Parallel

//1Thread -----------
//2Thread -----------


//synchronous

//1Thread -    ---    --
//2Thread   --     -      --

//asynchronous

// 1Main(UI) - - - - - - - -
//2Thread        --(load timeconsuming task(ex. load photo))


//UNIX-POSIX
var thread = pthread_t(bitPattern: 0) // creating the thread
var attribute = pthread_attr_t()
pthread_attr_init(&attribute)

pthread_create(&thread, &attribute, { arg in
    // Execute the closure (threadFunction) within the thread
//    threadFunction()
    return nil
}, nil)


// 2 thread objc shell
var nsthread = Thread {
    print("test")
}

nsthread.start()


// study note: iOS პროგრამირებაში URLSession-იც ოპერაცია დეფოლტად არის ასინქრონული ოპერაცია.რაც ნიშნავს, რომ ის მუშაობს ბექრაუნდ სრედზე და არა მთავარ ინტერფეისის სრედზე,ეს იმიტომ ხდება  რომ მეინ სრედის   არ დაიბლოკოს , რამაც შეიძლება გამოიწვიოს მომხმარებლის ინტერფეისის გაყინვა (დაფრიზვა)


class NetworkManager {
    // MARK: - Properties
    static let shared = NetworkManager()
    private let session = URLSession.shared
    
    // MARK: - Public Methods
    
    // Method to perform a GET request
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "NoDataError", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    // Method to perform a POST request
    func postData(to url: URL, body: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "NoDataError", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    // Method to download a file
    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let task = session.downloadTask(with: url) { (tempURL, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let tempURL = tempURL else {
                let error = NSError(domain: "NoTempURLError", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success(tempURL))
        }
        task.resume()
    }
    
    // Method to upload data
    func uploadData(to url: URL, data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = session.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "NoDataError", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}

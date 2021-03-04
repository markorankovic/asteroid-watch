public class MyNetworkManager : NSObject
{
    static let instance = MyNetworkManager()

    var downloadSession : URLSession?

    override init()
    {
        super.init()

        let downloadConfiguration = URLSessionConfiguration.default
        downloadSession = URLSession(configuration: downloadConfiguration, delegate: self, delegateQueue: nil)
    }

    func download(_ url : URL)
    {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let downloadTask = downloadSession?.downloadTask(with: urlRequest)

        downloadTask?.resume()
    }
}

extension MyNetworkManager: URLSessionDelegate {
    // this is intentionally blank

    // obviously, if you implement any delegate methods for this protocol, put them here
}

extension MyNetworkManager: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        print(#function)
    }

    public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print(#function)
    }
}

extension MyNetworkManager: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        print(#function, error ?? "No error")
    }
}


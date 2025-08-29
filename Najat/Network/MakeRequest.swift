import Foundation

protocol RequestMaker<T>: AnyObject {
    associatedtype T: Codable
    var network: any Network<T> { get }
    func addPathVariables(path: String...) -> Self
    func makeRequest(with body: JsonEncadable?) -> RequestPublisher<T>
    func makeRequest(with body: JsonEncadable?, uploadData: [UploadData]) -> RequestPublisher<T>
}

extension RequestMaker {
    func makeRequest(with body: JsonEncadable? = nil) -> RequestPublisher<T> {
        network
            .withBody(body)
            .asPublisher()
    }
    
    func makeRequest(with body: JsonEncadable? = nil, uploadData: [UploadData]) -> RequestPublisher<T> {
        network
            .withBody(body)
            .asPublisher(data: uploadData)
    }
    
    func addPathVariables(path: String...) -> Self {
        network.request.addPathVariables(path: path)
        return self
      }
}

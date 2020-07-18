import Foundation
import Combine

extension URLSession.DataTaskPublisher {
    func validate(for statusCodeRange: Range<Int> = 200..<300) -> AnyPublisher<Data, Error> {
        tryMap { (data: Data, response: URLResponse) -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            
            guard httpResponse.statusCode >= statusCodeRange.min()! && httpResponse.statusCode < statusCodeRange.max()! else {
                // FIXME: This doesn't throw the correct error
                throw URLError(.badServerResponse)
                // .wrongStatusCode(statusCode: httpResponse.statusCode, response: httpResponse)
            }
            
            return data
        }
        .eraseToAnyPublisher()
    }
}

import Foundation
import FirebaseStorage
import SwiftUI

class StorageDataSource: ObservableObject {
    // Get a reference to the storage service using the default Firebase App
    var storage: Storage
    var storageRef: StorageReference
    
    @Published var pokemonImageURL: URL?
    @Published var pokemonUSDZURL: URL?
    @Published var pokemonNames: [String] = []
    
    init(pokemonName: String) {
        print("DataSource 초기화")
        self.storage = Storage.storage()
        self.storageRef = storage.reference()
        fetchPokemonNames()
    }
    
    func fetchPokemonNames() {
        storageRef.child("thumbnail").listAll { (result, error) in
            if let error = error {
                print("Error getting files: \(error)")
            } else {
                guard let result = result else {
                    print("Error: result is nil")
                    return
                }

                for item in result.items {
                    let pokemonName = item.name.replacingOccurrences(of: ".png", with: "")
                    DispatchQueue.main.async {
                        self.pokemonNames.append(pokemonName)
                    }
                }
            }
        }
    }
    
    func getThumbnailURL(pokemonName: String, completion: @escaping (URL?) -> Void) {
        let pokemonRef = storageRef.child("thumbnail/\(pokemonName).png")
        pokemonRef.downloadURL { url, error in
            if let error = error {
                print("다운로드 URL 가져오는 중 오류: \(error)")
                completion(nil)
            } else {
                print("다운로드 URL이 성공적으로 가져와졌습니다: \(url!)")
                completion(url)
            }
        }
    }
    
    func downloadUSDZ(pokemonName: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let pokemonRef = storageRef.child("Usdz/\(pokemonName).usdz")
        // 임시 디렉토리 경로를 생성합니다.
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(pokemonName).usdz")
        
        // 파일 다운로드를 시작합니다.
        pokemonRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("USDZ 파일 다운로드 중 오류 발생: \(error)")
                completion(.failure(error))
            } else if let url = url {
                print("USDZ 파일이 성공적으로 다운로드되었습니다: \(url)")
                completion(.success(url))
            }
        }
    }
}

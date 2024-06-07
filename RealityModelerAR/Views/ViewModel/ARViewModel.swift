//
//  ARViewModel.swift
//  RealityModelerAR
//
//  Created by 홍승표 on 5/16/24.
//

import Foundation
import RealityKit
import ARKit

class ARViewModel: ObservableObject {
    var dataSource: StorageDataSource
    @Published private var model : ARModel
    var arView: ARView {
        model.arView
    }
    
    init(dataSource: StorageDataSource, model: ARModel) {
        self.dataSource = dataSource
        self.model = model
    }
    
    func placeObject(named entityName: String, for location: CGPoint) {
        let raycastQuery = arView.makeRaycastQuery(from: location,
                                                   allowing: .estimatedPlane,
                                                   alignment: .horizontal)
        
        if let query = raycastQuery {
            let results = arView.session.raycast(query)
            if let firstResult = results.first {
                let anchor = AnchorEntity(raycastResult: firstResult)
                
                dataSource.downloadUSDZ(pokemonName: entityName) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let url):
                            do {
                                let entity = try Entity.load(contentsOf: url)
                                entity.scale = SIMD3<Float>(0.005, 0.005, 0.005)
                                anchor.addChild(entity)
                                self.arView.scene.addAnchor(anchor)
                            } catch {
                                print("USDZ 파일을 엔티티로 로드하는데 실패했습니다: \(error)")
                            }
                        case .failure(let error):
                            print("USDZ 파일을 다운로드하는데 실패했습니다: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func resetScene() {
        arView.scene.anchors.removeAll()
    }
    
    func removeLastObject() {
        if let lastAnchor = arView.scene.anchors.compactMap({ $0 }).last {
            arView.scene.removeAnchor(lastAnchor)
        }
    }
    
    func snapshotAndSave() {
        arView.snapshot(saveToHDR: false) { image in
            guard let image = image else {
                print("사진 저장 실패")
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

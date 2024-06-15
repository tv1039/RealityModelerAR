# RealityModelerAR

## Overview
RealityModelerAR은 SwiftUI와 RealityKit을 사용하여 AR 경험을 제공하는 앱입니다.

## Features
- 간단 조작
- 모델 선택 및 배치
- 스냅샷 캡처 및 저장

## Steps

### Firebase Storage 설정
- Firebase 프로젝트를 생성하고 Firebase Storage를 설정합니다.
- Firebase 콘솔에서 스토리지 규칙을 설정하여 보안 및 접근 권한을 관리합니다.

### 파일 다운로드
- Firebase Storage SDK를 사용하여 .png 및 .usdz 파일을 다운로드합니다.
- 다운로드된 파일을 로컬 저장소에 저장하거나 메모리에서 직접 사용합니다.

### ARKit 및 RealityKit 설정
- Xcode 프로젝트에 ARKit과 RealityKit 프레임워크를 추가합니다.
- ARView를 설정하고 ARSession을 시작합니다.

### 사진 촬영 기능 구현
- ARView의 `snapshot()` 메서드를 사용하여 현재 AR 화면의 스냅샷을 생성합니다.
- 생성된 스냅샷을 사용자의 사진 라이브러리에 저장하거나 공유할 수 있도록 기능을 추가합니다.

## 객체 생성
사용자가 시트에서 선택한 썸네일 이미지와 동일한 이름을 가진 .usdz 소스(3D 모델)을 </br>
사용자의 터치 지점을 실제 세계의 위치로 변환하고, 그 위치에 가장 가까운 평면을 감지하는 데 사용되는 `raycast`을 통해 </br>
감지된 View의 평면 위로 정확하게 배치할 수 있도록 하였습니다.

### Code Example

```swift
func placeObject(named entityName: String, at location: CGPoint) {
    // 터치 위치에서 raycast 쿼리를 생성합니다
    guard let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal) else {
        return
    }
    
    // raycast를 수행합니다
    guard let raycastResult = arView.session.raycast(raycastQuery).first else {
        return
    }
    
    // raycast 결과에서 앵커 엔티티를 생성합니다
    let anchorEntity = AnchorEntity(raycastResult: raycastResult)
    
    // USDZ 파일을 다운로드하고 엔티티를 배치합니다
    dataSource.downloadUSDZ(pokemonName: entityName) { result in
        // 결과 처리 및 엔티티 배치 코드 추가
    }
}

```
## Firebase Storage에서 이미지 및 3D 겍체 모델을 다운로드합니다.

Firebase Storage에 저장된 모든 이미지 파일을 불러오는 기능을 추가하였습니다. 이를 통해 개발자가 직접 데이터를 추가할 필요 없이 Firebase Storage에 있는 이미지 파일을 모두 불러올 수 있습니다.

### Code Example
```swift
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

    func downloadUSDZ(pokemonName: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let pokemonRef = storageRef.child("Usdz/\(pokemonName).usdz")
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(pokemonName).usdz")
        
        pokemonRef.write(toFile: localURL) { url, error in
            if let error = error {
              print("Error getting Models: \(error)")
                completion(.failure(error))
            } else if let url = url {
                print("Success getting Models: \(url)")
                completion(.success(url))
            }
        }
    }
```

### Used Technologies
- `SwiftUI`
- `Combine`
- `ARKit`
- `RealityKit`
- `Firebase`
  
### Used Libraries
- `SDWebImageSwiftUI`

## ScreenShot
<img src = "https://github.com/tv1039/RealityModelerAR/assets/62321931/1d3864de-5b82-4c98-8053-48ca6271db80" width = "200px"> 
<img src = "https://github.com/tv1039/RealityModelerAR/assets/62321931/965f4903-b9a4-4d55-8483-d1e33a0d6218" width = "200px"> 

- 사용자가 객체를 평면에 자유롭게 제한 없이 배치할 수 있습니다.
- 두번째 사진은 우측 상단에 세 가지 버튼을 이용하여 객체 배치, 이전 상태 되돌리기, 전체 초기화를 결정할 수 있습니다.





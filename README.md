# RealityModelerAR

## Overview
RealityModelerAR은 SwiftUI와 RealityKit을 사용하여 AR 경험을 제공하는 앱입니다.

## Features
- 간단 조작
- 모델 선택 및 배치
- 카메라 전환 기능
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

## 이미지 캐싱
- SDWebImageSwiftUI를 활용하여 효율적인 이미지 캐싱과 빠른 로딩을 구현합니다.

## Code Example
사용자가 시트에서 선택한 썸네일 이미지와 동일한 이름을 가진 USDZ 파일을 AR 뷰에서 </br>
레이캐스팅을 통해 감지된 평면 위에 정확하게 배치할 수 있도록 하였습니다.
```swift
func placeObject(named entityName: String, at location: CGPoint) {
    // 터치 위치에서 레이캐스트 쿼리를 생성합니다
    guard let raycastQuery = arView.makeRaycastQuery(from: location,
                                                     allowing: .estimatedPlane,
                                                     alignment: .horizontal) else {
        print("레이캐스트 쿼리를 생성할 수 없습니다")
        return
    }
    
    // 레이캐스트를 수행합니다
    guard let raycastResult = arView.session.raycast(raycastQuery).first else {
        print("감지된 표면이 없습니다")
        return
    }
    
    // 레이캐스트 결과에서 앵커 엔티티를 생성합니다
    let anchorEntity = AnchorEntity(raycastResult: raycastResult)
    
    // USDZ 파일을 다운로드하고 엔티티를 배치합니다
    dataSource.downloadUSDZ(pokemonName: entityName) { result in
        // 결과 처리 및 엔티티 배치 코드 추가
    }
}

```

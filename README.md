# FLO-UIKit
<img width="903" alt="image" src="https://github.com/ksj0109188/FLO-UIKit/assets/48472569/3b56fd74-9f8b-40da-83bb-1a7073f4723a">

- 프로그래머스 과제테스트 FLO 앱 만들기 프로젝트입니다.
- UIKit Codebase, Combine framework를 활용 하였습니다.
- 기능개발과 더불어 유지보수가 용이한 구조와 코드 작성을 고민하며 개발을 진행했습니다.

## Skills
- UIKit(Code base), AutoLayout, AVKit
- Combine
- Clean Architecture with MVVM
- Coordinator, Delegate Pattern
  
## 프로젝트 요구사항
- 언어: Swift
- Deployment Target: iOS 10.0 -> combine사용을 위해 iOS 13.0으로 변경(자체적으로 하는 테스트이므로 임시로 변경했습니다.)
  
### 음악 재생 화면
- 주어진 노래의 재생 화면이 노출됩니다.
    - 앨범 커버 이미지, 앨범명, 아티스트명, 곡명이 함께 보여야 합니다.
- 재생 버튼을 누르면 음악이 재생됩니다. (1개의 음악 파일을 제공할 예정)
    - 재생 시 현재 재생되고 있는 구간대의 가사가 실시간으로 표시됩니다.
- 정지 버튼을 누르면 재생 중이던 음악이 멈춥니다.
- seekbar를 조작하여 재생 시작 시점을 이동시킬 수 있습니다.

### 전체 가사 보기 화면
- 전체 가사가 띄워진 화면이 있으며, 특정 가사 부분으로 이동할 수 있는 토글 버튼이 존재합니다.
    - 토글 버튼 on: 특정 가사 터치 시 해당 구간부터 재생
    - 토글 버튼 off: 특정 가사 터치 시 전체 가사 화면 닫기
- 전체 가사 화면 닫기 버튼이 있습니다.
- 현재 재생 중인 부분의 가사가 하이라이팅 됩니다.

### Architectrue
 <img width="1140" alt="image" src="https://github.com/ksj0109188/FLO-UIKit/assets/48472569/4ba6e4fb-29a1-4a4b-9af9-457d64751570">

### Foldering
```
FLO-UIKit
└─ sources
   ├─ FLO
   │  ├─ Application
   │  ├─ Data
   │  ├─ Domain
   │  │  ├─ Entities
   │  │  └─ UseCases
   │  ├─ Presentation
   │  │  ├─ DetailLyrics
   │  │  │  ├─ View
   │  │  │  └─ ViewModel
   │  │  ├─ Flow
   │  │  │  └─ PlaySongFlowCoordinator.swift
   │  │  └─ PlaySongScene
   │  │     ├─ View
   │  │     └─ ViewModel
   │  ├─ Resources
   │  └─ Utilities
   ├─ FLOTests
   └─ FLOUITests
```



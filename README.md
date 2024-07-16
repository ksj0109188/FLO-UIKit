# FLO-UIKit
<img width="903" alt="image" src="https://github.com/ksj0109188/FLO-UIKit/assets/48472569/3b56fd74-9f8b-40da-83bb-1a7073f4723a">

- 프로그래머스 과제테스트 FLO 앱 만들기 프로젝트입니다.
- UIKit Codebase, Combine framework를 활용 하였습니다.
- 기능개발과 더불어 유지보수가 용이한 구조와 코드 작성을 고민하며 개발을 진행했습니다.

## 1. Skills
- UIKit(Code base), AutoLayout, AVKit
- Combine
- Clean Architecture with MVVM
- Coordinator, Delegate Pattern
- XCTest
- SwiftLint
  
## 2. 프로젝트 요구사항
- 언어: Swift
- Deployment Target: iOS 10.0 -> combine사용을 위해 iOS 13.0으로 변경(자체적으로 하는 테스트이므로 임시로 변경했습니다.)
  
### 2-1. 음악 재생 화면
- 주어진 노래의 재생 화면이 노출됩니다.
    - 앨범 커버 이미지, 앨범명, 아티스트명, 곡명이 함께 보여야 합니다.
- 재생 버튼을 누르면 음악이 재생됩니다. (1개의 음악 파일을 제공할 예정)
    - 재생 시 현재 재생되고 있는 구간대의 가사가 실시간으로 표시됩니다.
- 정지 버튼을 누르면 재생 중이던 음악이 멈춥니다.
- seekbar를 조작하여 재생 시작 시점을 이동시킬 수 있습니다.

### 2-2. 전체 가사 보기 화면
- 전체 가사가 띄워진 화면이 있으며, 특정 가사 부분으로 이동할 수 있는 토글 버튼이 존재합니다.
    - 토글 버튼 on: 특정 가사 터치 시 해당 구간부터 재생
    - 토글 버튼 off: 특정 가사 터치 시 전체 가사 화면 닫기
- 전체 가사 화면 닫기 버튼이 있습니다.
- 현재 재생 중인 부분의 가사가 하이라이팅 됩니다.

## 3. Architecture
 <img width="1140" alt="image" src="https://github.com/ksj0109188/FLO-UIKit/assets/48472569/4ba6e4fb-29a1-4a4b-9af9-457d64751570">

## 4. 트러블 슈팅
### 4-1. 가사 상세화면 커스텀뷰
#### [이슈]
가사정보 표출과 동시에 사용자가 상호 작용 할 수 있는 컴포넌트로 TableView를 선택했습니다. 
동시에 토글버튼을 활용해 TableView를 컨트롤할 수 있는 '재생구간 선택' 기능이 필요했고 단순히 영역분리를 통해 구현 생각했습니다.
하지만 TableView에 Scroll Indicator표출이 디바이스 맨 오른쪽에 위치해야하는 문제가 있었고 단순 영역분리는 Indicator 원하는 위치가 아니었습니다.

#### [해결과정]
<div align="center">
  <img width="581" alt="image" src="https://github.com/user-attachments/assets/1c90f40c-0bce-4a26-a611-466a6a02c963"><br>
</div>
Xcode view hierarchy debug를 활용해 View의 구성을 시각화하며 고민했습니다. TableView의 넓이는 디바이스 크기만큼, TableView 위에 Toggle 버튼을 포함한 StackView 위치하는 것으로 해결했습니다.
TableView의 가사가 StackView 영역과 겹치는 이슈가 있었지만, 가사의 최대 길이를 StackView Leading영역까지 조정하는 것으로 해결했습니다.

```swift
    // TableView UITableViewDelegate
    // TableView에서 가사 Cell 생성 코드입니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailLyricsCell.reuseIdentifier, for: indexPath) as? DetailLyricsCell else { return UITableViewCell() }
        let Lyrics = viewModel.songDTO.transformedLyrics
        let timeLine = viewModel.songDTO.timeLineLyrics
        //가사 셀 생성과 동시에 길이를 정의합니다.
        cell.configure(lyrics: Lyrics[timeLine[indexPath.row]] ?? "", widthSize: sidebarWidth)
        
        if indexPath.row == focusedLyricsIndex {
            cell.highlight()
        } else {
            cell.disHighlight()
        }
        
        return cell
    } 
    
    // TableCell
    // 정의된 길이로 AutoLayout설정한 코드입니다.
    func configure(lyrics: String, widthSize: CGFloat) {
        lyricsLabel.text = lyrics
        self.widthSize = widthSize
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lyricsLabel.topAnchor.constraint(equalTo: topAnchor),
            lyricsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            lyricsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            lyricsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -widthSize)
        ])
    }

 ```
#### [결과]
<div align="center">
  <img width="270" alt="image" src="https://github.com/user-attachments/assets/4203502a-1f6d-4641-acad-ffb5fa14308a"><br>
  ✅가사길이가 아무리 길어도 조정되는 모습입니다.
</div>


#### [배운점]
SwiftUI로 개발했다면, 오히려 더 많은 고민과 서브뷰들이 탄생했을 거 같다는 생각을 했습니다. 
비록 현재 SwiftUI가 최신 트렌드이고 Apple의 적극적인 업데이트가 있지만, UIKit을 안 쓸 수는 없다고 생각하게 되었습니다. 
또한 커스텀 뷰를 개발하며 TableView 사용법과 View Hiearchy Debug 사용법을 자세히 알게 되었습니다.


### 4-2. 가사상세화면과 메인화면 동기화
#### [이슈]
가사상세 화면에서 재생 중인 구간, 하이라이트 되어야 하는 가사, 음악 재생상태 및 Slider 진행률이 메인뷰(부모뷰)와 동기화가 필요한 이슈가 있었습니다.
#### [해결과정]
MVVM-C 패턴이 적용된 프로젝트로, 참조타입을 활용해 인스턴스를 공유하면 동기화 기능이 가능하다 생각했습니다.
코드는 다음과 같습니다.
```swift
//coordinator에 적용된 화면 흐름입니다.
   private func showDetailLyrics(songDTO: SongDTO, playerManager: PlayerManager) {
        let actions = DetailLyricsViewModelActions(dismissDetailLyricsView: dismissDetailLyricsView)
        // 주입된 위존성을 기반으로 ViewController생성
        let vc = dependencies.makeDetailLyricsSceneViewController(songDTO: songDTO, playerManager: playerManager, actions: actions)
        // 뷰 표출
        navigationController?.pushViewController(vc, animated: false)
    }

// DIContainer에서 의존성 주입하는 코드입니다.
// 파라미터로 playerManager와 songDTO를 입력받습니다. 인스턴스를 공유하기 위해 클래스 타입으로 지정했으며 이를 기반으로 서브뷰인 DetailLyricsSceneViewController를 생성합니다.
func makeDetailLyricsSceneViewController(songDTO: SongDTO, playerManager: PlayerManager, actions: DetailLyricsViewModelActions) -> DetailLyricsSceneViewController {
    let vc = DetailLyricsSceneViewController()
    vc.create(viewModel: makeDetailLyricsTableViewModel(songDTO: songDTO, playerManager: playerManager, actions: actions))
    
    return vc
}

func makeDetailLyricsTableViewModel(songDTO: SongDTO, playerManager: PlayerManager, actions: DetailLyricsViewModelActions) -> DetailLyricsViewModel {
        return DetailLyricsViewModel(songDTO: songDTO, playerManger: playerManager, actions: actions)
    }
```

#### [결과]
<div align="center">
  <img width="270" alt="image" src="https://github.com/user-attachments/assets/215dbe73-8f3e-48ce-b8cd-f0128c35a9c6"><br>
  ✅가사구간 클릭 및 재생구간도 뷰와 서브뷰간 동기화 됩니다.
</div>

#### [배운점]
참조타입과 MVVM-C 패턴을 어떻게 활용해야 하는지 고민하며 이해도가 생긴 것 같습니다. 또한 해당 프로젝트에선 1:1 관계를 통해 인스턴스를 공유하지만, 만약 여러
뷰가 존재한다면 "DeadLock 외 Race Condition에 대한 문제발생 가능성"을 생각했습니다.

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



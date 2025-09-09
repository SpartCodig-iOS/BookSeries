//
//  BaseViewController.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 9/5/25.
//

import UIKit

import Combine
import ComposableArchitecture

open class BaseViewController<
  RootView: UIView,
    Feature: Reducer
>: UIViewController where Feature.State: Equatable {

  // MARK: - Properties
  /// 루트 뷰 인스턴스 걍  일
  public let rootView: RootView

  /// TCA Store
  public let store: StoreOf<Feature>

  /// ViewStore for observing state
  public let viewStore: ViewStoreOf<Feature>

  /// Combine cancellables
  public var cancellables: Set<AnyCancellable> = []

  // MARK: - Initialization

  public init(rootView: RootView, store: StoreOf<Feature>) {
    self.rootView = rootView
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  open override func loadView() {
    view = rootView
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    configureUI()
    bindActions()
//    bindState()
  }

  // MARK: - Setup Methods

  /// 뷰의 기본 설정 (배경색, 기본 속성 등)
  open func setupView() {
    view.backgroundColor = .basicBlack
  }

  /// UI 구성 등 추가 설정
  /// 서브클래스에서 오버라이드하여 사용
  open func configureUI() {
    // Override in subclass
  }

  /// 액션 바인딩
  /// 서브클래스에서 오버라이드하여 UI 액션을 TCA 액션으로 연결
  open func bindActions() {
    // Override in subclass
  }

  /// 상태 바인딩
  /// 서브클래스에서 오버라이드하여 TCA 상태를 UI에 반영
  open func bindState() {
    // Override in subclass
  }
}


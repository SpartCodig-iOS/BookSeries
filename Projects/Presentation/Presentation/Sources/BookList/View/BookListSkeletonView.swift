//
//  BookListSkeletonView.swift
//  Presentation
//
//  Created by Claude on 9/10/25.
//

import UIKit
import Shared
import SnapKit
import Then

public final class BookListSkeletonView: BaseView {
  
  private let rootView = UIView()
  
  // 메인 스택
  private let mainVerticalStack = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 0
    $0.alignment = .fill
    $0.distribution = .fill
  }
  
  // MARK: - 헤더 스켈레톤
  
  private let headerContainer = UIView()
  
  private let titleSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  private let seriesNumberSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 25
    $0.clipsToBounds = true
  }
  
  // MARK: - 시리즈 버튼 스켈레톤
  
  private let seriesButtonsContainer = UIView()
  private let seriesButtonStack = UIStackView.horizontal(spacing: 12, alignment: .center)
  
  // MARK: - 스크롤 영역
  
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
  }
  private let scrollContentView = UIView()
  private let scrollStack = UIStackView.vertical(spacing: 24, alignment: .fill, distribution: .fill)
  
  // MARK: - 카드 스켈레톤
  
  private let cardContainer = UIView.makeContainer(.init(backgroundColor: .clear, cornerRadius: 12))
  private let cardHorizontalStack = UIStackView.horizontal(spacing: 16, alignment: .leading)
  
  private let bookImageSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  private let cardInfoVerticalStack = UIStackView.vertical(spacing: 8, alignment: .leading, distribution: .fill)
  
  private let cardTitleSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private let authorSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private let dateSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private let pagesSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  // MARK: - 상세 정보 스켈레톤
  
  private let detailsContainer = UIView()
  
  private let dedicationTitleSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private let dedicationTextSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private let summaryTitleSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private let summaryTextSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  // MARK: - 목차 스켈레톤
  
  private let chaptersContainer = UIView()
  private let chaptersTitleSkeletonView = UIView().then {
    $0.backgroundColor = .systemGray4
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private let chaptersStack = UIStackView.vertical(spacing: 8, alignment: .leading, distribution: .fill)
  
  // MARK: - Life cycle
  
  public override func addView() {
    super.addView()
    addSubview(rootView)
    setupViewHierarchy()
    setupConstraints()
    startShimmerAnimation()
  }
  
  private func setupViewHierarchy() {
    // 메인 구조
    rootView.addSubviews(mainVerticalStack)
    mainVerticalStack.addArrangedSubviews(headerContainer, seriesButtonsContainer, scrollView)
    
    mainVerticalStack.setCustomSpacing(24, after: headerContainer)
    mainVerticalStack.setCustomSpacing(16, after: seriesButtonsContainer)
    
    // 헤더
    headerContainer.addSubviews(titleSkeletonView, seriesNumberSkeletonView)
    
    // 시리즈 버튼
    seriesButtonsContainer.addSubviews(seriesButtonStack)
    setupSeriesButtonSkeleton()
    
    // 스크롤 영역
    scrollView.addSubviews(scrollContentView)
    scrollContentView.addSubviews(scrollStack)
    scrollStack.addArrangedSubviews(cardContainer, detailsContainer, chaptersContainer)
    scrollStack.setCustomSpacing(32, after: cardContainer)
    
    // 카드 섹션
    cardContainer.addSubviews(cardHorizontalStack)
    cardHorizontalStack.addArrangedSubviews(bookImageSkeletonView, cardInfoVerticalStack)
    cardInfoVerticalStack.addArrangedSubviews(
      cardTitleSkeletonView,
      authorSkeletonView,
      dateSkeletonView,
      pagesSkeletonView
    )
    
    // 상세 정보 섹션
    detailsContainer.addSubviews(
      dedicationTitleSkeletonView,
      dedicationTextSkeletonView,
      summaryTitleSkeletonView,
      summaryTextSkeletonView
    )
    
    // 목차 섹션
    chaptersContainer.addSubviews(chaptersTitleSkeletonView, chaptersStack)
    setupChaptersSkeleton()
  }
  
  private func setupSeriesButtonSkeleton() {
    // 7개의 시리즈 버튼 스켈레톤 생성
    for _ in 1...7 {
      let buttonSkeleton = UIView().then {
        $0.backgroundColor = .systemGray4
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
      }
      
      seriesButtonStack.addArrangedSubview(buttonSkeleton)
      buttonSkeleton.snp.makeConstraints { make in
        make.width.height.equalTo(44)
      }
    }
  }
  
  private func setupChaptersSkeleton() {
    // 5개의 목차 스켈레톤 생성
    for i in 0..<5 {
      let chapterSkeleton = UIView().then {
        $0.backgroundColor = .systemGray4
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
      }
      
      chaptersStack.addArrangedSubview(chapterSkeleton)
      chapterSkeleton.snp.makeConstraints { make in
        make.height.equalTo(16)
        // 각기 다른 너비로 자연스럽게
        let widthMultiplier = 0.6 + (Double(i) * 0.1)
        make.width.equalToSuperview().multipliedBy(widthMultiplier)
      }
    }
  }
  
  private func setupConstraints() {
    // rootView: 안전영역
    rootView.snp.makeConstraints { make in
      make.edges.equalTo(self.safeAreaLayoutGuide)
    }
    
    // 메인 스택
    mainVerticalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview()
    }
    
    // 헤더 스켈레톤
    titleSkeletonView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(60)
    }
    
    seriesNumberSkeletonView.snp.makeConstraints { make in
      make.top.equalTo(titleSkeletonView.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(50)
      make.bottom.equalToSuperview()
    }
    
    // 시리즈 버튼 컨테이너
    seriesButtonStack.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
      make.height.equalTo(44)
    }
    
    // 스크롤 컨텐츠
    scrollContentView.snp.makeConstraints { make in
      make.edges.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(scrollView.frameLayoutGuide)
    }
    scrollStack.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    // 카드 스켈레톤
    cardHorizontalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalToSuperview().offset(-8)
    }
    
    bookImageSkeletonView.snp.makeConstraints { make in
      make.width.equalTo(80)
      make.height.equalTo(120)
    }
    
    cardTitleSkeletonView.snp.makeConstraints { make in
      make.height.equalTo(24)
    }
    
    authorSkeletonView.snp.makeConstraints { make in
      make.height.equalTo(16)
      make.width.equalToSuperview().multipliedBy(0.6)
    }
    
    dateSkeletonView.snp.makeConstraints { make in
      make.height.equalTo(14)
      make.width.equalToSuperview().multipliedBy(0.7)
    }
    
    pagesSkeletonView.snp.makeConstraints { make in
      make.height.equalTo(14)
      make.width.equalToSuperview().multipliedBy(0.4)
    }
    
    // 상세 정보 스켈레톤
    dedicationTitleSkeletonView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(20)
      make.width.equalTo(100)
    }
    
    dedicationTextSkeletonView.snp.makeConstraints { make in
      make.top.equalTo(dedicationTitleSkeletonView.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(40)
    }
    
    summaryTitleSkeletonView.snp.makeConstraints { make in
      make.top.equalTo(dedicationTextSkeletonView.snp.bottom).offset(24)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(20)
      make.width.equalTo(80)
    }
    
    summaryTextSkeletonView.snp.makeConstraints { make in
      make.top.equalTo(summaryTitleSkeletonView.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(80)
      make.bottom.equalToSuperview()
    }
    
    // 목차 스켈레톤
    chaptersTitleSkeletonView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(20)
      make.width.equalTo(80)
    }
    
    chaptersStack.snp.makeConstraints { make in
      make.top.equalTo(chaptersTitleSkeletonView.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Shimmer Animation
  
  private func startShimmerAnimation() {
    let allSkeletonViews = [
      titleSkeletonView, seriesNumberSkeletonView,
      bookImageSkeletonView, cardTitleSkeletonView, authorSkeletonView, dateSkeletonView, pagesSkeletonView,
      dedicationTitleSkeletonView, dedicationTextSkeletonView,
      summaryTitleSkeletonView, summaryTextSkeletonView,
      chaptersTitleSkeletonView
    ]
    
    // 시리즈 버튼 스켈레톤 추가
    let seriesButtonSkeletons = seriesButtonStack.arrangedSubviews
    let chapterSkeletons = chaptersStack.arrangedSubviews
    
    let allViews = allSkeletonViews + seriesButtonSkeletons + chapterSkeletons
    
    for view in allViews {
      addShimmerEffect(to: view)
    }
  }
  
  private func addShimmerEffect(to view: UIView) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor.systemGray4.cgColor,
      UIColor.systemGray3.cgColor,
      UIColor.systemGray4.cgColor
    ]
    gradientLayer.locations = [0, 0.5, 1]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.frame = view.bounds
    
    view.layer.addSublayer(gradientLayer)
    
    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [-1.0, -0.5, 0.0]
    animation.toValue = [1.0, 1.5, 2.0]
    animation.duration = 1.5
    animation.repeatCount = .infinity
    
    gradientLayer.add(animation, forKey: "shimmer")
    
    // 레이아웃이 변경될 때 gradientLayer 프레임 업데이트
    DispatchQueue.main.async {
      gradientLayer.frame = view.bounds
    }
  }
  
  public func stopShimmerAnimation() {
    // 모든 서브레이어에서 애니메이션 제거
    func removeShimmerFromView(_ view: UIView) {
      view.layer.sublayers?.forEach { layer in
        if layer is CAGradientLayer {
          layer.removeAllAnimations()
          layer.removeFromSuperlayer()
        }
      }
      view.subviews.forEach { removeShimmerFromView($0) }
    }
    
    removeShimmerFromView(self)
  }
}
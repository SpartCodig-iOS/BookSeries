//
//  FallbackViewController.swift
//  Utill
//
//  Created by Wonji Suh  on 9/8/25.
//

import UIKit

@MainActor
public final class FallbackViewController: UIViewController {
  public init(title: String) { super.init(nibName: nil, bundle: nil); self.title = title }
  public required init?(coder: NSCoder) { fatalError() }
  public override func viewDidLoad() { super.viewDidLoad(); view.backgroundColor = .white }
}


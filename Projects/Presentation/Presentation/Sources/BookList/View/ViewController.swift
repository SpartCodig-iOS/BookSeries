//
//  ViewController.swift
//  Presentation
//
//  Created by Wonji Suh  on 9/5/25.
//

import UIKit
import Core
import ComposableArchitecture
import Repository

public class ViewController: UIViewController {
  private let store: StoreOf<BookList>
    private let viewStore: ViewStore<BookList.State, BookList.Action>

  public init(store: StoreOf<BookList>) {
      self.store = store
      self.viewStore = ViewStore(store, observe: { $0 })
      super.init(nibName: nil, bundle: nil)
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

    public override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = .white
      Task {
         store.send(.async(.fetchBook))
      }


    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

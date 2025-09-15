//
//  Modules.swift
//  Plugins
//
//  Created by 서원지 on 2/21/24.
//

import Foundation
import ProjectDescription

public enum ModulePath {
  case Presentation(Presentations)
  case Core(Cores)
  case Network(Networks)
  case Interface(Interfaces)
  case Domain(Domains)
  case Data(Datas)
  case Shared(Shareds)
}

// MARK: FeatureModule
public extension ModulePath {
  enum Presentations: String, CaseIterable {
    case Presentation


    public static let name: String = "Presentation"
  }
}

//MARK: -  CoreMoudule
public extension ModulePath {
  enum Cores: String, CaseIterable {
    case Core
    
    public static let name: String = "Core"
  }
}

//MARK: -  CoreDomainModule
public extension ModulePath {
  enum Networks: String, CaseIterable {
    case API
    case Network
    case Foundations
    case Model
    case Service
    case DiContainer
    case UseCase
    case ThirdPartys
    
    
    public static let name: String = "Network"
  }
}

//MARK: -  CoreMoudule
public extension ModulePath {
  enum Datas: String, CaseIterable {
    case Model
    case Repository

    public static let name: String = "Data"
  }
}


//MARK: -  CoreMoudule
public extension ModulePath {
  enum Domains: String, CaseIterable {
    case UseCase
    case DomainInterface
    case QRCode


    public static let name: String = "Domain"
  }
}

//MARK: -  CoreMoudule
public extension ModulePath {
  enum Interfaces: String, CaseIterable {
    case Interface


    public static let name: String = "Interface"
  }
}


public extension ModulePath {
  enum Shareds: String, CaseIterable {
    case Shared
    case DesignSystem
    case Utill
    case ThirdParty
    
    public static let name: String = "Shared"
  }
}



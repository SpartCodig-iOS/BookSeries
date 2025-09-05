import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "ThirdParty",
  bundleId: .appBundleID(name: ".ThirdParty"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .SPM.composableArchitecture,
    .SPM.flexLayout,
    .SPM.then,
    .SPM.pinLayout
  ],
  sources: ["Sources/**"]
)

import Foundation
import UIKit
import StoreKit

class Global {
    class var shared : Global {
        
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    
    
    var user:UserViewModel!
    var isLogedIn:Bool = false
       
    
  }


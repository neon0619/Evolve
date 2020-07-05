
import Foundation
import UIKit


typealias ParamsAny             = [String:Any]
typealias ParamsString          = [String:String]

let ALERT_TITLE_APP_NAME        = "Pete Evans"
let EMAIL_REGULAR_EXPRESSION    = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

struct APIKeys {
    static let googleApiKey     = "AIzaSyBTfypSbx_zNMhWSBXMTA2BJBMQO7_9_T8"
}

struct StoryboardNames {
    static let Main             = "Main"
    static let Profile          = "Profile"
    static let Registeration    = "Registeration"
    static let ReceipeDetails   = "ReceipeDetails"
}

struct NavigationTitles {
    static let Home             = "Home"
//    static let Search           = "Search Recipes"
//    static let Results          = "Results"
    static let Settings         = "Settings"
    static let Instructions     = "Cooking Instructions"
    static let MyCookbook       = "My Cookbook"
    static let ShoppingList     = "Shopping List"
    static let Subscription     = "Subscription"
    static let Ingredients      = "Ingredients"
    static let UpdateProfile    = "Update Profile"
}

struct NotificationName {
    static let UnAuthorizedAccess    = Notification.Name(rawValue: "UnAuthorizedAccess")
}

struct AssetNames {
    static let backArrow            = "back Arrow"
    static let listView             = "icon_list_view"
    static let gridView             = "icon_grid_view"
    static let recipePlaceHolder    = "Image 9"
    static let iconProfile          = "icon profile"
    static let iconChecked          = "icon_checked"
    static let iconUnchecked        = "icon_unchecked"
    static let introImage1          = "Image 19"
    static let introImage2          = "Image 23"
    static let introImage3          = "Image 22"
    static let introImage4          = "Image 24"
    static let introImage5          = "gradient_intro"
  
}
struct ServiceMessage {
    static let LocationTitle       = "Location Service Off"
    static let LocationMessage     = "Turn on Location in Settings > Privacy to allow myLUMS to determine your Location"
    static let Settings            = "Settings"
    static let CameraTitle         = "Permission Denied"
    static let CameraMessage       = "Turn on Camera in Settings"
}

struct ControllerIdentifier {
    static let HomeViewController                   = "HomeViewController"
    static let MainTabBarController                 = "MainTabBarController"
    static let SigninViewController                 = "SigninViewController"
    static let SignupViewController                 = "SignupViewController"
    static let GetPincodeViewController             = "GetPincodeViewController"
    static let UpdatePasswordViewController         = "UpdatePasswordViewController"
    static let SettingsViewController               = "SettingsViewController"
    static let MainContainerViewController          = "MainContainerViewController"
    static let SearchReceipeViewController          = "SearchReceipeViewController"
    static let SearchResultsViewController          = "SearchResultsViewController"
    static let ReceipeDetailsViewController         = "ReceipeDetailsViewController"
    static let CookingInstructionViewController     = "CookingInstructionViewController"
    static let CookbookViewController               = "CookbookViewController"
    static let ShoppingListViewController           = "ShoppingListViewController"
    static let SubscriptionViewController           = "SubscriptionViewController"
    static let UpdateProfileViewController          = "UpdateProfileViewController"
    static let ShoppingDetailsViewController        = "ShoppingDetailsViewController"
    static let BaseIntroductionViewController       = "BaseIntroductionViewController"
    static let FilterPopupViewController            = "FilterPopupViewController"
}

struct ValidationMessages {
    static let loginSuccessfully            = "You are logged in"
    static let selectProfileimage           = "Select Profile Image"
    static let emptyName                    = "Please enter your name"
    static let enterValidEmail              = "Incorrect email"
    static let emptyPassword                = "Incorrect password"
    static let shortPassword                = "Password must be atleast 6 characters"
    static let reTypePassword               = "Please re-type password"
    static let nonMatchingPassword          = "Password is not matching"
    static let invalidPhoneNumber           = "Enter a valid phone number"
    static let configurationUrl             = "Please enter configuration url"
    static let validUrl                     = "Please enter valid url"
    static let emptyPhonNumber              = "Please enter phone number"
    static let emptyPincode                 = "Please enter pincode from email to continue"
    static let emptyCategoryName            = "Please enter category name first"
    static let emptyProductName             = "Please enter product name first"
    static let invalidProductPrice          = "Please enter a valid price for product"
    static let emptyProductInfo             = "Please describe product briefly"
    static let noImageProduct               = "Add at least one image of product"
    static let selectWeightUnit             = "Select product weight unit first"
    static let commentsMissing              = "Comment field cannot empty"
    static let noLocationAdded              = "Location info is must in order to become a supplier"
}

struct PopupMessages {
    static let warning                      = "Warning"
    static let sureToLogout                 = "Are you sure to logout"
    static let nothingToUpdate              = "Nothing to update"
    static let fbLoginCanceled              = "Login Cancelled"
    static let searchKeywordEmpty           = "Search keyword not found"
    static let fbEmailRequired              = "Email permission is mandatory to login with facebook account"
    static let unAuthorizedAccess           = "Session expired, please login again"
    static let cameraPermissionNeeded       = "Camera permission needed to scan QR Code. Goto settings to enable camera permission"
    static let SomethingWentWrong           = "Something went wrong, please check your internet connection or try again later!"
    static let sureToMarkUnfavorite         = "Are you sure to remove this recipe from your Cookbook?"
    static let sureToRemoveFromShopping     = "Are you sure to remove this recipe from shopping list?"
}

struct LocalStrings {
    static let success              = "Success"
    static let ok                   = "OK"
    static let Yes                  = "Yes"
    static let No                   = "No"
    static let add                  = "add"
    static let edit                 = "Edit"
    static let remove               = "remove"
    static let delete               = "Delete"
    static let Cancel               = "Cancel"
    static let Camera               = "Camera"
    static let complete             = "COMPLETE"
    static let prepare              = "PREPARE"
    static let update               = "UPDATE"
    static let favorite             = "favorite"
    static let unfavorite           = "unfavorite"
    static let NoDataFound          = "No data found"
    static let EnterUsername        = "Enter Username"
    static let EnterEmail           = "Enter Email"
    static let OldPassword          = "Old Password"
    static let EnterOldPassword     = "Enter old password"
    static let ChangePassword       = "CHANGE PASSWORD"
    static let noDescription        = "No description available"
    static let cancellationReason   = "Cancellation Reason"
    static let editProfile          = "EDIT PROFILE"
    static let updateProfile        = "UPDATE PROFILE"
}

struct AppFonts {
    static func ProximaNovaReguler(ofSize size : CGFloat) -> UIFont {
        
        if let font = UIFont(name: "ProximaNova-Regular", size: size) {
            return font
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

import Foundation
import UIKit

struct SettingsList {
    static let data = [["title":"","image":""],
                       ["title":"Edit Profile","image":"profile"],
                       ["title":"Manage Membership","image":"membership"],
                       ["title":"Restore Purchase","image":"restore_purchase"],
                       ["title":"Logout","image":"logout"],
                       ["title":"Help & Support","image":"help and support"],
                       ["title":"Contact","image":"contact"],
                       ["title":"About","image":"about"]]
}


struct AppColors {
    static let selectedText     = UIColor(hexFromString: "#C7C5B6")
    static let textColor        = UIColor(hexFromString: "#707070")
    static let yellowText       = UIColor(hexFromString: "#85754E")
    static let DarkBlue         = UIColor(hexFromString: "0x093485")
    static let imageBackColor   = UIColor(rgbValues: 252, green: 66, blue: 73)
    static let lightOverlay     = UIColor(hexFromString: "85754E", alpha: 0.75)
    static let darkOverlay      = UIColor(hexFromString: "000000", alpha: 0.65)
}

struct DictKeys {
    static let userId               = "user_id"
    static let name                 = "name"
    static let email                = "email"
    static let password             = "password"
    static let loginType            = "login_type"
    static let pincode              = "pincode"
    static let newPassword          = "new_password"
    static let currentPassword      = "current_password"
    static let recipeId             = "recipe_id"
    static let status               = "status"
    static let meal                 = "meal"
    static let diet                 = "diet"
    static let time                 = "time"
    static let searchText           = "search_text"
    static let profileImage         = "profile_image"
    static let ingredientList       = "checked_ingridient_list"
    static let spicesList           = "checked_spice_paste_ingredients"
    static let garlicShallotList    = "checked_fried_shallots_or_garlic_ingredients"
}

struct EndPoints {
    static let BASE_URL                 = "http://mashghol.com/pete-evans/public/api/"
    static let logout                   = "logout"
    static let login                    = "login"
    static let Register                 = "register"
    static let updateProfile            = "update_profile"
    static let forgetPassword           = "forget_password"
    static let changePassword           = "change_password"
    static let updatePassword           = "update_password"
    static let HomeData                 = "get_home_listing"
    static let getReceipeDetails        = "get_recipe_detail"
    static let favouriteReceipe         = "favorite_recipe"
    static let getFavoriteListing       = "get_favorite_listing"
    static let searchRecipes            = "search_recipe"
    static let getShoppingList          = "get_shopping_list"
    static let addToShoppingList        = "add_recipe_shopping_list"
    static let updateIngredientList     = "update_ingridient_list"
    static let getAllCategories         = "get_all_categories"
}

//Default values for data types
let kBlankString = ""
let Plateform = "IOS"
let DeviceToken = "21321312"

let kInt0 = 0
let kIntDefault = -1

let kDouble0 = 0.0
let kDoubleDefault = -1.0

let kFileTypePDF = "pdf"
let kFileTypeJpeg = "jpeg"

let kMimeTypeImage = "image/png"
let kImageFileName = "file.png"

let kMimeTypePDF = "application/pdf"
let kPDFFileName = "document.pdf"




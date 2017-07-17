//
//  ViewController.swift
//  RecipeApp
//
//  Created by Rahul Kumar on 6/8/17.
//  Copyright © 2017 Rahul Kumar. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UIWebViewDelegate, UISearchBarDelegate, UITextFieldDelegate, PayPalPaymentDelegate{

    @IBOutlet var WebView: UIWebView!
    var currentURL:String = ""
    let webViewforData = WKWebView()
    var stringforvalue:String = ""
    var boolForSubstring:Bool = false
    var incremetor:Int = 0
    var newPriceString:String = ""
    var NextQoute: Bool = false
    var UrlBeforeSent: String = ""
    var StringforIngredients: String = ""
    var Price:Double = 0.0
    var ChangeNewLabel:Bool = false
    var ArrayForIngredients = [String]()
    var NumberofTimesWebViewLoaded:Int = 0
    let CanGoBack = UIImage(named: "arrow_back_white_192x192")
    let canGoForward = UIImage(named: "arrow_forward_white_192x192")
    let CantGoBack = UIImage(named: "arrowBackWhenCantGoBack")
    let cantGoForward = UIImage(named: "arrowForwardWhenCantGoForward")
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    var LabelForInsertingIngredients = UILabel()
    let grayView = UIView()
    var arrayForDisplayItems = [UILabel]()
    var LabelforInsertingCost = UILabel()
    var ArrayforType = [String]()
    var arrayforCost = [Double]()
    var arrayforDisplayingCost = [UILabel]()
    var arrayForDeleteButtons = [UIButton]()
    var servingsstring = ""
    var deleteButtonImage = UIImage(named: "MinusSign")
    var addButtonImage = UIImage(named: "PlusSign")
    let toolbar = UIToolbar()
    var buttonTag = 0
    var titleOfRecipe = ""
    static var conditionforShippingAddressIsFulfilled = 0
    static var URLforOrderInfo = ""
    static var IngredientsArrayForMySQLtransfer = [UILabel]()
    static var CostsArrayForMySQLtransfer = [UILabel]()
    static var OriginalIngredientsArrayForMySQLtransfer = [String]()
    static var OriginalCostsArrayForMySQLtransfer = [Double]()

    
    
   var theBool: Bool!
   var myTimer: Timer!

    @IBOutlet var LoaderView: UIView!
    @IBOutlet var Masterview: UIView!
    @IBOutlet var Orderbutton: UIButton!
    //@IBOutlet var SmallSearchRecipes: UILabel!
    @IBOutlet var BigSearchRecipes: UILabel!
    @IBOutlet var WhiteBar: UIImageView!
    @IBOutlet var BackArrow: UIButton!
    @IBOutlet var ForwardArrow: UIButton!
    @IBOutlet var OrderView: UIView!
    @IBOutlet var PriceTextinOrderView: UILabel!
    @IBOutlet var ActivitySpinner: UIActivityIndicatorView!
    @IBOutlet var ActivityIndicatorforWeb: UIActivityIndicatorView!
    @IBOutlet var StackViewForIngredients: UIStackView!
    @IBOutlet var StackViewForCost: UIStackView!
    @IBOutlet var PaynowButton: UIButton!
    @IBOutlet var ServingsLabel: UILabel!
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var FoogleImageView: UIImageView!
    @IBOutlet var FoogleLogo: UILabel!
    @IBOutlet var TextFieldToEnterMore: UITextField!
    @IBOutlet var ActivityIndicatorForTextField: UIActivityIndicatorView!
    @IBOutlet var ActivityIndicatorforPriceLabel: UIActivityIndicatorView!
    @IBOutlet var StackViewForDeleteButtons: UIStackView!
    @IBOutlet var StepperOutlet: UIStepper!
    @IBOutlet var ShippingTaxesServicesLabel: UILabel!
    @IBOutlet var ServicePrice: UILabel!
    
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Foogle Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both;

        Orderbutton.layer.cornerRadius = 10
        SearchBar.text = ""
        ActivityIndicatorForTextField.isHidden = true
        ActivityIndicatorForTextField.startAnimating()
        TextFieldToEnterMore.delegate = self
        TextFieldToEnterMore.placeholder = "Add Other or Missing"
        ActivityIndicatorforPriceLabel.isHidden = true
        ActivityIndicatorforPriceLabel.startAnimating()
        TextFieldToEnterMore.returnKeyType = UIReturnKeyType.done
        
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([flexibleSpace,doneButton], animated: false)
        
        SearchBar.spellCheckingType = .yes
        SearchBar.autocorrectionType = .yes
        
        TextFieldToEnterMore.inputAccessoryView = toolbar
        
        webViewforData.navigationDelegate = self
        SearchBar.delegate = self
        WebView.delegate = self
        //SmallSearchRecipes.isHidden = true
        
        self.OrderView.frame.origin.y = 667
        OrderView.layer.cornerRadius = 10
        //PaynowButton.layer.cornerRadius = 10
        
        ActivitySpinner.isHidden = true
        ActivitySpinner.startAnimating()
        LoaderView.isHidden = true
        LoaderView.layer.cornerRadius = 10
        //LoaderView.addBlurEffect()
        Orderbutton.isHidden = true
        
        
        //grayView.isHidden = true
        self.grayView.frame = self.view.bounds
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.addSubview(grayView)
        self.grayView.addSubview(LoaderView)
        self.grayView.isHidden = true
        self.ActivityIndicatorforWeb.isHidden = true
        self.ActivityIndicatorforWeb.startAnimating()
        //StackViewForIngredients.removeFromSuperview()
        
        StepperOutlet.minimumValue = 1
        StepperOutlet.maximumValue = 25
        StepperOutlet.autorepeat = true
        StepperOutlet.isHidden = true
        ServingsLabel.isHidden = true
        self.ShippingTaxesServicesLabel.textColor = UIColor.gray
        self.ServicePrice.textColor = UIColor.gray
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func doneClicked(){
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if(textField.text != "")
        {
        ActivityIndicatorForTextField.isHidden = false
        PriceTextinOrderView.isHidden = true
        ActivityIndicatorforPriceLabel.isHidden = false
        let convertedtextfieldtext = textField.text as! String
        
        let Url = "http://ec2-13-58-166-251.us-east-2.compute.amazonaws.com/test.html?Data=\(convertedtextfieldtext)"
        print(Url)
        var stringforvalue = ""
        var newPriceString = ""
        var incremetor = 0
        var boolforSubstring = false
        
        let urlSet = CharacterSet.urlQueryAllowed
            .union(CharacterSet.punctuationCharacters)
        
        let UrlBeforeSent = Url.addingPercentEncoding(withAllowedCharacters: urlSet)!
        print(UrlBeforeSent)
        
        let foodPriceUrl = URL(string: UrlBeforeSent)
        let requestforPrice = URLRequest(url: foodPriceUrl!)
        self.webViewforData.load(requestforPrice)
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.webViewforData.evaluateJavaScript("document.getElementsByTagName('body')[0].innerHTML", completionHandler: { (value, error) in
                //print(value)
                stringforvalue = value as! String
                print(stringforvalue)
                
                if stringforvalue.range(of:"price:") != nil{
                    print("hi")
                    
                    
                    let range: Range<String.Index> = stringforvalue.range(of: "Cost per Serving: $")!
                    let index: Int =  stringforvalue.distance(from: stringforvalue.startIndex, to: range.lowerBound)
                    incremetor = index + 19
                    
                    
                    while boolforSubstring == false
                    {
                        if(stringforvalue[incremetor] != "<")
                        {
                            newPriceString = newPriceString + stringforvalue[incremetor]
                            print(newPriceString)
                            incremetor = incremetor + 1
                        }
                        else
                        {
                            
                            var labelforInsertingintoPrice = UILabel()
                            labelforInsertingintoPrice.text = "$\(newPriceString)"
                            labelforInsertingintoPrice.textColor = UIColor.gray
                            self.StackViewForCost.addArrangedSubview(labelforInsertingintoPrice)
                            self.arrayforDisplayingCost.append(labelforInsertingintoPrice)
 
                            var labelForInsertingintoIngredients = UILabel()
                            labelForInsertingintoIngredients.text = convertedtextfieldtext
                            labelForInsertingintoIngredients.textColor = UIColor.gray
                            self.StackViewForIngredients.addArrangedSubview(labelForInsertingintoIngredients)
                            self.arrayForDisplayItems.append(labelForInsertingintoIngredients)
                            
                            var deleteButton = UIButton()
                            deleteButton.setTitle("x", for: UIControlState.normal)
                            deleteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                            deleteButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
                            deleteButton.addTarget(self, action: "removeFromStackView:", for: UIControlEvents.touchUpInside)
                            deleteButton.tag = self.buttonTag
                            print("\(self.buttonTag)")
                            self.buttonTag = self.buttonTag + 1
                            self.arrayForDeleteButtons.append(deleteButton)
                            self.StackViewForDeleteButtons.addArrangedSubview(deleteButton)
                            
                            var DoublefornewPriceString = Double(newPriceString)
                            let roundedDoublefornewPriceString = round(100 * DoublefornewPriceString!) / 100
                            self.Price = roundedDoublefornewPriceString + self.Price
                            
                            self.arrayforCost.append(roundedDoublefornewPriceString)
                            self.PriceTextinOrderView.text = "Price: $\(self.Price)"
                            
                            self.PriceTextinOrderView.isHidden = false
                            self.ActivityIndicatorforPriceLabel.isHidden = true
                            self.ActivityIndicatorForTextField.isHidden = true
                            textField.text = ""
                            boolforSubstring = true
                        }
                    }
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Sorry", message: "The Ingredient you entered did not yield a price.", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                        self.ActivityIndicatorForTextField.isHidden = true
                        textField.text = ""
                        self.ActivityIndicatorforPriceLabel.isHidden = true
                        self.PriceTextinOrderView.isHidden = false
                    }
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
        }
        }
        

        return true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchBar.resignFirstResponder()
        print("hi")
        let stringforURL = SearchBar.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) as! String
        //print(stringforURL)
        

        let urlSearch = URL(string: "https://www.google.com/search?ei=h3JeWeuwAYjRmAHG4aPgCg&q=\(stringforURL)+recipe&oq=spaghetti+&gs_l=mobile-gws-serp.1.0.41j0i67k1j0i46i67k1j46i67k1l2.25403.26647.0.27706.11.11.0.1.1.0.887.3922.2-5j4j1j0j1.11.0....0...1.1.64.mobile-gws-serp..6.5.1193.3..0j46j0i131k1j0i46k1.LMr8hsAQS2o")
        let request = URLRequest(url: urlSearch!)
        WebView.loadRequest(request)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc(webViewDidStartLoad:) func webViewDidStartLoad(_ webView: UIWebView)
    {
         ActivityIndicatorforWeb.isHidden = false
         BigSearchRecipes.isHidden = true
         SearchBar.placeholder = "Foogle"
         //checkArrowStatus()
    }
    

    
    func checkArrowStatus()
    {
        if(WebView.canGoBack == true)
        {
            
            UIWebView.transition(with: self.BackArrow,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.BackArrow.setImage(self.CanGoBack, for: UIControlState.normal)
            })
        }
        
        else if(WebView.canGoForward == true)
        {
            
            UIWebView.transition(with: self.ForwardArrow,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.ForwardArrow.setImage(self.canGoForward, for: UIControlState.normal)
            })
        }
        else if(WebView.canGoBack == false)
        {
            
            UIWebView.transition(with: self.BackArrow,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.BackArrow.setImage(self.CantGoBack, for: UIControlState.normal)
            })
        }
        
        else if(WebView.canGoForward == false)
        {
            
            UIWebView.transition(with: self.ForwardArrow,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.ForwardArrow.setImage(self.cantGoForward, for: UIControlState.normal)
            })
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
            ActivityIndicatorforWeb.isHidden = true
            //checkArrowStatus()
        
            SearchBar.inputAccessoryView = toolbar
        
            let currenturl = (WebView.request?.url?.absoluteString)!
            //print(currenturl)
        
            FoogleImageView.isHidden = true
            let newFrameForSearchBar = CGRect.init(x: 0, y: 60, width: SearchBar.layer.frame.width, height: SearchBar.layer.frame.height)
            SearchBar.frame = newFrameForSearchBar
            FoogleLogo.isHidden = true
        
            Orderbutton.isHidden = false
    }
    
    
    
    
    func FindIngredientPrice(Ingredient: String){
        
        //print("http://ec2-13-58-166-251.us-east-2.compute.amazonaws.com/test.html?Data=\(Ingredient)")

        self.UrlBeforeSent = "http://ec2-13-58-166-251.us-east-2.compute.amazonaws.com/test.html?Data=\(Ingredient)"
        
        let urlSet = CharacterSet.urlQueryAllowed
            .union(CharacterSet.punctuationCharacters)
        
        self.UrlBeforeSent = self.UrlBeforeSent.addingPercentEncoding(withAllowedCharacters: urlSet)!
        
        let foodPriceUrl = URL(string: self.UrlBeforeSent)
        print ("ravi....\(foodPriceUrl)")
        let requestforPrice = URLRequest(url: foodPriceUrl!)
        self.webViewforData.load(requestforPrice)
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
        
        self.webViewforData.evaluateJavaScript("document.getElementsByTagName('body')[0].innerHTML", completionHandler: { (value, error) in
            //print(value)
            self.stringforvalue = value as! String
            print(self.stringforvalue)
            var stringforIndivPrice = ""
            var boolforIndivPrice = false
            var incrematorforIndivPrice = 0
            
            if self.stringforvalue.range(of:"price:") != nil{


                let rangeforIndivPrice: Range<String.Index> = self.stringforvalue.range(of: "<br>$")!
                let indexforIndivPrice: Int = self.stringforvalue.distance(from: self.stringforvalue.startIndex, to: rangeforIndivPrice.lowerBound)
                incrematorforIndivPrice = indexforIndivPrice + 4
                var toCheckIfcontained = ""
                var toCheckIfItemWasParsed = 0
                
                print(self.stringforvalue)
                
                for item in self.ArrayForIngredients
                {
                    self.LabelForInsertingIngredients = UILabel()
                    self.LabelforInsertingCost = UILabel()
                    
                    self.LabelForInsertingIngredients.textColor = UIColor.gray
                    self.LabelforInsertingCost.textColor = UIColor.gray
                    
                    toCheckIfcontained = "\(self.ArrayforType[toCheckIfItemWasParsed])<br>"
                    print("\(self.ArrayforType[toCheckIfItemWasParsed])<br>")
                    if self.stringforvalue.range(of: toCheckIfcontained) != nil {
                        
                        self.LabelForInsertingIngredients.text = item
                    
                        self.arrayForDisplayItems.append(self.LabelForInsertingIngredients)
                    }
                    else
                    {
                        self.ArrayForIngredients.remove(at: toCheckIfItemWasParsed)
                    }
                    boolforIndivPrice = false
                        
                    
                    
                   if(self.stringforvalue[incrematorforIndivPrice] == "$")
                   {
                    incrematorforIndivPrice += 1
                    while boolforIndivPrice == false
                    {
                        if(self.stringforvalue[incrematorforIndivPrice] != "<")
                        {
                            stringforIndivPrice = stringforIndivPrice + self.stringforvalue[incrematorforIndivPrice]
                            incrematorforIndivPrice = incrematorforIndivPrice + 1
                        }
                        else
                        {
                            boolforIndivPrice = true
                            self.LabelforInsertingCost.text = "$\(stringforIndivPrice)"
                            let IndivPriceConvertedIntoDouble = Double(stringforIndivPrice)
                            let roundedIndivPrice = round(100 * IndivPriceConvertedIntoDouble!) / 100
                            self.Price += roundedIndivPrice
                            print("INDIVPRICE:\(roundedIndivPrice)")
                            self.arrayforCost.append(roundedIndivPrice)
                            self.arrayforDisplayingCost.append(self.LabelforInsertingCost)
                            self.StackViewForCost.addArrangedSubview(self.LabelforInsertingCost)
                        }
                    }
                    }
                    incrematorforIndivPrice += 4
                    print(stringforIndivPrice)

                    
                    
                    
                    if self.stringforvalue.range(of: toCheckIfcontained) != nil {
                        print("inserted:\(item)")
                        self.StackViewForIngredients.addArrangedSubview(self.LabelForInsertingIngredients)
                        var deleteButton = UIButton()
                        deleteButton.setTitle("x", for: UIControlState.normal)
                        deleteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                        deleteButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
                        deleteButton.addTarget(self, action: "removeFromStackView:", for: UIControlEvents.touchUpInside)
                        deleteButton.tag = self.buttonTag
                        print("\(item):\(self.buttonTag)")
                        self.buttonTag = self.buttonTag + 1
                        self.arrayForDeleteButtons.append(deleteButton)
                        self.StackViewForDeleteButtons.addArrangedSubview(deleteButton)
                    }
                    stringforIndivPrice = ""
                    toCheckIfItemWasParsed = toCheckIfItemWasParsed + 1
                }
                
                let serviceCharge = String((round(100 * (self.Price * 0.14))  / 100) + 2.00)
                //print("SERVICE CHARGE: \(serviceCharge)")
                
                self.ServicePrice.text = "$\(serviceCharge)"
                
                //self.Price += Double(serviceCharge)!
                
                self.Price += Double(serviceCharge)!
                
                self.PriceTextinOrderView.text = "Price: $\(self.Price)"
                print(self.Price)
                self.ActivitySpinner.isHidden = true
                self.LoaderView.isHidden = true
                self.grayView.isHidden = true

                if !UIAccessibilityIsReduceTransparencyEnabled() {
                    self.view.backgroundColor = UIColor.clear
                    //always fill the view
                    self.blurEffectView.frame = self.view.bounds
                    //CGRect.init(x: 0, y: 86, width: self.WebView.frame.width, height: self.WebView.frame.height)
                    self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    
                    
                    UIView.transition(with: self.Masterview,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.view.addSubview(self.blurEffectView)
                                        self.view.addSubview(self.OrderView)
                                        self.OrderView.addSubview(self.PaynowButton)
                                        self.OrderView.layoutIfNeeded()
                                        self.PaynowButton.clipsToBounds = true
                                        self.PaynowButton.layer.cornerRadius = 10
                                        self.OrderView.addSubview(self.ServingsLabel)
                                        self.ServingsLabel.clipsToBounds = true
                                })

                        
                } else {
                    self.view.backgroundColor = UIColor.black
                }
                
                
                let gesture = UITapGestureRecognizer(target: self, action: "someAction:")
                self.blurEffectView.addGestureRecognizer(gesture)
                

                
                UIView.animate(withDuration: 1, animations: {
                    self.OrderView.frame.origin.y = 70
                    
                })


                self.newPriceString = ""
                self.boolForSubstring = false
                self.NextQoute = false
                self.incremetor = 0
                self.UrlBeforeSent = ""
                
            }
            
        })
            
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Loaded")
    }

    @IBAction func OnOrderPress(_ sender: Any) {
        
        self.grayView.isHidden = false
        LoaderView.isHidden = false
        ActivitySpinner.isHidden = false
        var checkifrecipe = true
        
        currentURL = (WebView.request?.url?.absoluteString)!
        ViewController.URLforOrderInfo = currentURL
        print(currentURL)
        ArrayForIngredients = [String]()
        
        let uRl = URL(string: "http://ec2-13-58-166-251.us-east-2.compute.amazonaws.com/SERVER/index.php?url=" + currentURL)
        
        let task = URLSession.shared.dataTask(with: uRl!) { (data, response, error) in
            
            
            if error != nil {
                let alert = UIAlertController(title: "Uh-Oh!", message: "The Server is down right now.", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                    self.grayView.isHidden = true
                }
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                if let mydata = data {
                    do {
                        
                        let myJson = try JSONSerialization.jsonObject(with: mydata, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        //self.StepperOutlet.value = Double(self.servingsstring)!
                        
                        if let status = myJson["status"] as? String {
                            if(status == "failure")
                            {
                                let alert = UIAlertController(title: "Error", message: "This recipe cannot be extracted.", preferredStyle: UIAlertControllerStyle.alert)
                                let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                    self.grayView.isHidden = true
                                }
                                alert.addAction(cancelAction)
                                
                                self.present(alert, animated: true, completion: nil)

                            }
                        }
                        
                        if let title = myJson["title"] as? String
                        {
                            self.titleOfRecipe = title
                        }
                        
                        if let Recipedifferentiater = myJson["text"] as? String
                        {
                            if let servings = myJson["servings"] as? Int {
                                self.servingsstring = String(servings)
                                print("SERVINGS:\(self.servingsstring)")
                                self.ServingsLabel.text = "Servings: \(self.servingsstring)"
                            }

                        
                        if let stations = myJson["extendedIngredients"] as? [[String: AnyObject]] {
                            
                            for station in stations {
                                
                                if let name = station["originalString"] as? String{

                                   var constructedstring = ""
                                    
                                   if let amount = station["amount"] as? Double
                                   {
                                      constructedstring = "\(amount)"
                                   }
                                   if let unitShort = station["unitShort"] as? String
                                   {
                                      constructedstring = constructedstring + " \(unitShort)"
                                   }
                                   if let name = station["name"] as? String
                                   {
                                      constructedstring = constructedstring + " \(name)"
                                      self.ArrayforType.append(name)
                                   }
                                
                                   print(constructedstring)
                                   self.ArrayForIngredients.append(constructedstring)
                                    
                                }
                                
                            }
                            }
                            
                        }
                        else
                        {
                            print("This is not a recipe")
                            checkifrecipe = false
                            
                            let alert = UIAlertController(title: "Uh-Oh!", message: "Foogle could not recognize this webpage to be a recipe.", preferredStyle: UIAlertControllerStyle.alert)
                            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                            self.grayView.isHidden = true
                            }
                            alert.addAction(cancelAction)
                                                                
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                    catch {
                        // catch error
                    }
                }
            }
            
            if(checkifrecipe == true)
            {
                for item in self.ArrayForIngredients {
                
                    if(item == self.ArrayForIngredients[self.ArrayForIngredients.count - 1])
                    {
                        self.StringforIngredients = "\(self.StringforIngredients) \(item)"
                        break
                    }
                    self.StringforIngredients = "\(self.StringforIngredients) \(item) %0A"
                }
                self.StringforIngredients = self.StringforIngredients.trimmingCharacters(in: .whitespacesAndNewlines)
                print(self.StringforIngredients)
                self.FindIngredientPrice(Ingredient: self.StringforIngredients)
                self.StringforIngredients = ""
            }
        }
        
        task.resume()
        
        
        

    }
    
    func someAction(_ sender:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.75, animations: {
            self.OrderView.frame.origin.y = self.Masterview.frame.origin.y + self.Masterview.frame.size.height
            
        })
        let when = DispatchTime.now() + 0.75 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIView.transition(with: self.Masterview,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.blurEffectView.removeFromSuperview()
                                for i in 0 ... self.arrayForDisplayItems.count - 1
                                {
                                    self.arrayForDisplayItems[i].removeFromSuperview()
                                }
                                for i in 0 ... self.arrayForDeleteButtons.count - 1
                                {
                                    self.arrayForDeleteButtons[i].removeFromSuperview()
                                }
                                for i in 0 ... self.arrayforDisplayingCost.count - 1
                                {
                                    self.arrayforDisplayingCost[i].removeFromSuperview()
                                }
                                self.arrayForDisplayItems = [UILabel]()
                                self.arrayforDisplayingCost = [UILabel]()
                                self.ArrayForIngredients = [String]()
                                self.ArrayforType = [String]()
                                self.arrayforCost = [Double]()
                                self.buttonTag = 0
                                self.Price = 0.0
            })
            
        }
        
    }
    
    
    
    @IBAction func onSettingsPress(_ sender: Any) {
        print(self.Price)
        performSegue(withIdentifier: "SegueToSettings", sender: self)
    }
    
    func removeFromStackView(_ sender:UIButton)
    {
        
        for i in 0 ... self.arrayForDeleteButtons.count - 1
        {
          if(sender.tag == i)
          {
            sender.removeTarget(self, action: "addBackToStackView:", for: UIControlEvents.touchUpInside)
            let attributedString = NSMutableAttributedString(attributedString: self.arrayForDisplayItems[i].attributedText!)
            
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.red, range: NSMakeRange(0, attributedString.length))
            
            self.arrayForDisplayItems[i].attributedText = attributedString
            self.arrayForDisplayItems[i].accessibilityHint = "removed"
            
            let attributedStringforCost = NSMutableAttributedString(string: self.arrayforDisplayingCost[i].text!)
            attributedStringforCost.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, attributedStringforCost.length))
            attributedStringforCost.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.red, range: NSMakeRange(0, attributedStringforCost.length))
            
            self.arrayforDisplayingCost[i].attributedText = attributedStringforCost
            self.arrayforDisplayingCost[i].accessibilityHint = "removed"
            
            print("\(self.Price) - \(self.arrayforCost[i])")
            
            self.Price = self.Price - self.arrayforCost[i]
            let roundedSelfPrice = round(100 * self.Price) / 100
            self.PriceTextinOrderView.text = "Price: $\(abs(roundedSelfPrice))"
            
            sender.setTitle("+", for: UIControlState.normal)
            sender.setTitleColor(UIColor.blue, for: UIControlState.normal)
            sender.addTarget(self, action: "addBackToStackView:", for: UIControlEvents.touchUpInside)
          }
        }
    }
    
    func addBackToStackView(_ sender:UIButton)
    {
        for i in 0 ... self.arrayForDeleteButtons.count - 1
        {
            if(sender.tag == i)
            {
                sender.removeTarget(self, action: "removeFromStackView", for: UIControlEvents.touchUpInside)
                let originalString = NSMutableAttributedString(string: self.arrayForDisplayItems[i].text!)
                self.arrayForDisplayItems[i].attributedText = originalString
                self.arrayForDisplayItems[i].accessibilityHint = "added"
                
                let originalStringForCost = NSMutableAttributedString(string: self.arrayforDisplayingCost[i].text!)
                self.arrayforDisplayingCost[i].attributedText = originalStringForCost
                self.arrayforDisplayingCost[i].accessibilityHint = "added"
                
                print("\(self.Price) + \(self.arrayforCost[i])")
                self.Price = self.Price + self.arrayforCost[i]
                let roundedSelfPrice = round(100 * self.Price) / 100
                self.PriceTextinOrderView.text = "Price: $\(abs(roundedSelfPrice))"
                
                sender.setTitle("x", for: UIControlState.normal)
                sender.setTitleColor(UIColor.red, for: UIControlState.normal)
                sender.addTarget(self, action: "removeFromStackView:", for: UIControlEvents.touchUpInside)

            }
        }
    }
    
    
    @IBAction func OnBackPress(_ sender: Any) {
       
       if(WebView.canGoBack)
       {
          WebView.goBack()
          //checkArrowStatus()
       }
    }
    
    
    @IBAction func OnForwardPress(_ sender: Any) {
        
        if(WebView.canGoForward)
        {
           WebView.goForward()
           //checkArrowStatus()
        }
    }
    
    
    @IBAction func ServingsStepper(_ sender: UIStepper) {
        self.ServingsLabel.text = "Servings: \(Int(sender.value).description)"
    }
    
    
    func initiatePayPalController()
    {
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        
        let nameFromSearchBartext = SearchBar.text as! String
        let priceFromLabel = String(self.Price)
        
        
        // Optional: include multiple items
        let item1 = PayPalItem(name: "Base Item + Service Charge", withQuantity: 1, withPrice: NSDecimalNumber(string: priceFromLabel), withCurrency: "USD", withSku: "Hip-0037")
        
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: self.titleOfRecipe, intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self as! PayPalPaymentDelegate)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }

    }
    
    override func viewDidAppear(_ conditionforShippingAddressIsFulfilled: Bool) {
        
        if let shippingSetup = UserDefaults.standard.object(forKey: "Shipping Setup") as? Bool
        {
          if(shippingSetup == true)
          {
            initiatePayPalController()
            UserDefaults.standard.set(false, forKey: "Shipping Setup")
          }
        }

    }
    
    
    
    @IBAction func OnPayPress(_ sender: Any) {
        resultText = ""
        if let shippingSetup = UserDefaults.standard.object(forKey: "Shipping Setup") as? Bool
        {
            initiatePayPalController()
        }
        else
        {
            performSegue(withIdentifier: "ViewControllerForShippingInfo", sender: self)
        }
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        resultText = ""
        //successView.isHidden = true
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            self.resultText = completedPayment.description
            ViewController.IngredientsArrayForMySQLtransfer = self.arrayForDisplayItems
            ViewController.CostsArrayForMySQLtransfer = self.arrayforDisplayingCost
            ViewController.OriginalIngredientsArrayForMySQLtransfer = self.ArrayForIngredients
            ViewController.OriginalCostsArrayForMySQLtransfer = self.arrayforCost
            
            self.performSegue(withIdentifier: "SegueToOrderInfo", sender: self)
            
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//
//  RecViewController.swift
//  iWeather
//
//  Created by Ria Buhlin on 2018-04-02.
//  Copyright © 2018 Ria Buhlin. All rights reserved.
//

import UIKit

class RecViewController: UIViewController {

    @IBOutlet weak var frame: UIView!
    
    @IBOutlet weak var cityLabel: UILabel!
    var test : String!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var shoesImage: UIImageView!
    @IBOutlet weak var jacketImage: UIImageView!
    
    @IBOutlet weak var propsImage: UIImageView!
    @IBOutlet weak var propsImage2: UIImageView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var vindImage: UIImageView!
    
    var bollGravity : UIGravityBehavior!
    var gravity : UIGravityBehavior!
    @IBOutlet weak var boll: UIImageView!
    
    var currentWeatherCondition : String? = ""
    var currentTemp : Int? = 0
    var currentWind : Int? = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    bollGravity = UIGravityBehavior(items: [boll])
    gravity = UIGravityBehavior(items: [conditionImage])
    cityLabel.text = test
    checkWeather()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func checkWeather() {
        if currentTemp! < -5 {
            backgroundImage.image = UIImage(named: "Vinter")
        }
        
        if currentTemp! <= 5 {
            jacketImage.image = UIImage(named: "Vinterjacka")
            shoesImage.image = UIImage(named: "Boots")
            if currentTemp! < -5 {
                propsImage.image = UIImage(named: "Mossa")
                propsImage2.image = UIImage(named: "Halsduk")
            }
        } else if currentTemp! > 5 && currentTemp! < 15 {
            jacketImage.image = UIImage(named: "Varjacka")
            shoesImage.image = UIImage(named: "Uggs")
            
        } else if currentTemp! < 20 {
            jacketImage.image = UIImage(named: "Hoddie")
        }
        
        if currentWind! > 10 {
            vindImage.isHidden = false
        }
        
        
        if currentWeatherCondition == "Snow" {
            conditionImage.image = UIImage(named: "Sno")
            //letItSnow()
        } else if currentWeatherCondition == "Rain" {
            
            conditionImage.image = UIImage(named: "Regn")
           // letItSnow()
            propsImage.image = UIImage(named: "Paraply")
            if currentTemp! < 15 {
                jacketImage.image = UIImage(named: "Regnjacka")
                shoesImage.image = UIImage(named: "Stovlar")
            }
            
        } else if currentWeatherCondition == "Clear" {
            propsImage.image = UIImage(named: "Solbrillor")
            conditionImage.image = UIImage(named: "Sol")
                if currentTemp! > 19 {
                    backgroundImage.image = UIImage(named: "Strand")
                    bottomImage.image = UIImage(named: "Kjol")
                    shoesImage.isHidden = true
                    boll.isHidden = false
                  
                }
            }
        }
   
    @IBAction func ballTapped(_ sender: UITapGestureRecognizer) {
 
        let bottom = self.view.frame.height - 80
        let bredd = self.view.frame.width
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: 0.2, animations: {
            self.boll.center.y = bottom
            self.boll.center.x = bredd / 4
        }) { (complete) in
            UIView.animate(withDuration: 0.2, animations: {
                self.boll.center.y = bottom - 200
                self.boll.center.x = bredd / 3
            }) { (complete) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.boll.center.y = bottom
                    self.boll.center.x = bredd / 2
                }) { (complete) in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.boll.center.y = bottom - 150
                        self.boll.center.x = bredd / 1.5
                    }) { (complete) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.boll.center.y = bottom
                            self.boll.center.x = bredd - 80
                        }) { (complete) in
                            UIView.animate(withDuration: 0.6, animations: {
                                self.boll.center.y = bottom - 100
                                self.boll.center.x = bredd
                            }) { (complete) in
                                UIView.animate(withDuration: 0.7, animations: {
                                    self.boll.center.y = bottom
                                    self.boll.center.x = bredd + 100
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func letItSnow() {
        
    
            UIView.animate(withDuration: 0.5, animations: {
                self.conditionImage.center.y = self.view.frame.height / 2
            }) { (complete) in
                UIView.animate(withDuration: 0, animations: {
                   self.conditionImage.center.y = self.view.frame.height - (self.conditionImage.center.y - 10)
                }) { (complete) in
                        self.letItSnow()
                }
            }
        }
 

}

//
//  ViewController.swift
//  weather
//
//  Created by Macx on 2020/1/20.
//  Copyright © 2020 Macx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func btnAction(_ sender: Any) {
        print("btn cilic")
        loadWeather()
        getnetwork()
        post()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadWeather()
    }
    func loadWeather() -> NSInteger {
        // 数据获取
        let url = URL(string: "http://www.weather.com.cn/data/sk/101010100.html")
        let data:Data
        var dic:[String : Any]
        do {
            data = try Data.init(contentsOf: url!)
            dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments)  as! [String : Any]
            let weatherinfo:[String : Any] = dic["weatherinfo"] as! [String : Any]
            let city = weatherinfo["city"]
            let temp = weatherinfo["temp"]
            
            let WD = weatherinfo["WD"]
            let WS = weatherinfo["WS"]
            
            textView.text="城市：\(city!)\n温度：\(String(describing: temp!))\n风：\(WD!)\n风级：\(WS!)\n"
            print(WD!)
        } catch let error as NSError {
            print(error)
        }
        
        
        
        return 0
    }
    @objc func updatTextView(str:String) {
        textView.text=str
    }
    @objc func test()  {
        
    }
    func getnetwork() -> Bool {
        var url = "http://www.weather.com.cn/data/sk/101010100.html"
        //let key = "许嵩"
        //url=url+key
        //url=url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let config = URLSessionConfiguration.default
        let kUrl = URL(string: url)
        let request = URLRequest(url: kUrl!)
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if data==nil{
            print("get 数据为空")
            }else{
                let dic=try?JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(dic!)
                let str=String.init(data: data!, encoding: .utf8)
                let selector=#selector(self.updatTextView(str:))
                self.performSelector(onMainThread:selector, with: str, waitUntilDone: true)
            }
        }
        
        task.resume()
        
        
        
        
        
        
        return true
    }
    
    func post()  {
        let session = URLSession(configuration: .default)
        let url = "http://www.weather.com.cn/data/sk/101010100.html"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod="POST"
        let postData=["name":"me","password":"123456"]
        let postStr=postData.compactMap { (key,value) -> String in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        //request.httpBody=postStr.data(using: .utf8)
        let task=session.dataTask(with: request) { (data, respons, error) in
  
            if data==nil{
            print("post 数据为空")
            }else{
                let dic=try?JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if dic==nil {
                    
                }else{
                print(dic!)
                let str=String.init(data: data!, encoding: .utf8)
                DispatchQueue.main.async {
                    self.textView.text="post------"
                }
                }
            }
        }
        task.resume()
        
    }
    
}



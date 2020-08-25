//
//  WNHomeVC.swift
//  WhiteNoise
//
//  Created by 朱桂磊 on 2020/8/24.
//  Copyright © 2020 layne_zhu. All rights reserved.
//

import UIKit

class WNHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "首页"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = ViewController.init()
        navigationController?.pushViewController(vc, animated: true)
        
        
        GLApp?.wx_sendAuthRequest()
        WNNetwork.request(url: "api/app/init", params: nil, success: { (result: BaseDataModel<DataModel>) in
            
        }) { (code, msg, err) in
            
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

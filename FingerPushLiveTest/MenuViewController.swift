//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tblMenuOptions : UITableView!

    var arrayMenuOptions = [Dictionary<String,String>]()

    var delegate : SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateArrayMenuOptions()

        tblMenuOptions.tableFooterView = UIView()
        
        tblMenuOptions.rowHeight = UITableView.automaticDimension
        tblMenuOptions.estimatedRowHeight = 700
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! MenuViewControllerCell

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear

        cell.imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        cell.lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let index = Int(indexPath.row)
        delegate?.slideMenuItemSelectedAtIndex(index)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"알림", "icon":"icon_1_notice"])
        arrayMenuOptions.append(["title":"태그", "icon":"icon_2_tag"])
        arrayMenuOptions.append(["title":"타겟팅", "icon":"icon_3_targeting"])
        arrayMenuOptions.append(["title":"개발정보", "icon":"icon_4_info"])
        arrayMenuOptions.append(["title":"이용가이드", "icon":"icon_5_guide"])
        arrayMenuOptions.append(["title":"이용문의", "icon":"icon_6_call"])
        arrayMenuOptions.append(["title":"알림설정", "icon":"icon_7_setting"])
        
        tblMenuOptions.reloadData()
    }

}

//
//  IssuesViewController.swift
//  KAPU
//
//  Created by Andrii Verbovetskyi on 3/4/17.
//  Copyright © 2017 Vasyl Khmil. All rights reserved.
//

import UIKit

class IssuesViewController: UIViewController {

    @IBOutlet var table: UITableView!
    let kapus = KapuLoader()
    var selectedKapuIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotificationCenter()
        kapus.getKapusFromFB{
            self.table.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kapus.getKapusFromFB {
            self.table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(IssuesViewController.updateKapus),
                                               name: NSNotification.Name(rawValue: "KapusWereUpdated"),
                                               object:nil)
    }
    
    func updateKapus() {
        self.table.reloadData()
    }

}

extension IssuesViewController :UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 187
    }
    
}

extension IssuesViewController :UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return kapus.allKapus.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell", for: indexPath) as! IssueTableViewCell
        let kapu = kapus.allKapus[indexPath.row]
        cell.categoryLabel.text = kapu.categoryName
        cell.issueDescriptionLabel.text = kapu.title
        cell.authorLabel.text = kapu.creatorName
        cell.dateLabel.text = kapu.creationDate
        cell.issuePicture.image = kapu.image
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // goToKapuDetails
        self.selectedKapuIndex = indexPath.row
       // performSegue(withIdentifier: "goToKapuDetails", sender: nil)

    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let secondViewController = segue.destination as! KapuViewController
        
        // set a variable in the second view controller with the data to pass
        secondViewController.kapu = self.kapus.allKapus[self.selectedKapuIndex]
    }
}

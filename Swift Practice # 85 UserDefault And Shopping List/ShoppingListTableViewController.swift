//
//  ShoppingListTableViewController.swift
//  Swift Practice # 85 UserDefault And Shopping List
//
//  Created by Dogpa's MBAir M1 on 2021/10/1.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {

    
    //建立一個空字串命名為shoppingItems
    var shoppingItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()

    }

    // MARK: - Table view data source
    
    //TableView Section為1
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //數量為自定義shoppingItems總數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingItems.count
    }

    //顯示內容為shoppingItems內的資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)

        cell.textLabel?.text = shoppingItems[indexPath.row]

        return cell
    }
    
    
    //新增項目的加號按鈕
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        //透過closure的方式建立警告控制器
        showAlert(nil, withCompletionHandler: {
            (sucess:Bool, result:String?) in
            if sucess == true {
                if let okResult = result {
                    self.shoppingItems.append(okResult)
                    //self.tableView.reloadData()
                    let insertInfoAtThisIndexPath = IndexPath(row: self.shoppingItems.count-1, section: 0)
                    self.tableView.insertRows(at: [insertInfoAtThisIndexPath], with: .automatic)
                    self.saveList()
                }
            }
        })
    }
    
    //自定義func將shoppingItems透過UserDefaults存入以便後續讀取使用
    func saveList () {
        UserDefaults.standard.setValue(shoppingItems, forKey: "list")
    }
    
    //自定義func透過UserDefaults讀取shoppingItems，透過if let取值以免造成崩潰
    func loadList () {
        if let okList = UserDefaults.standard.stringArray(forKey: "list") {
            shoppingItems = okList
        }
    }
    
    let handler:(Bool,String?)->() = {
        (sucess:Bool, result:String?) in
        if sucess == true {
            if let okResult = result {
                //shoppingItems.append(okResult)
            }
        }
    }
    
    //自定義func來顯示警告控制器與輸入控制器的內容後的執行項目
    func showAlert (_ addValue: String?, withCompletionHandler handler: @escaping (Bool,String?)->()) {
        //將alert指派後使用UIAlertController功能
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        //在警告控制器新增TextField，並顯示提醒項目
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "請輸入提醒購買物品"
            textField.text = addValue                   //輸入文字存入addValue後續使用
        })
        //新增一個OK的按鈕並處理按下OK後要執行的項目，按下OK後儲存TaxtField內的資料並更新tableview
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            if let inputText = alert.textFields?[0].text {
                if inputText != "" {
                    handler(true,inputText)
                }else{
                    handler(false,nil)
                }
            }
        })
        //新增一個Cancel的按鈕並處理按下Cancel後要處理的項目
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: {
            (action) in
            handler(false,nil)
        })
        //加入OK以及Cancel的按鈕後並present製作好的alert
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //點擊驚嘆號後需要執行的項目
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //點擊後跳出警告控制器
        showAlert(shoppingItems[indexPath.row], withCompletionHandler: {
            (sucess:Bool, result:String?) in
            //判斷原本點到的row內是否有值，也就是原本是否有提醒事項，若有將原本的內容顯示到TextField內ㄅ
            //修改後按ok再次存入shoppingItems並重新更新tableview並且存入到UserDefaults內
            if sucess == true {
                if let okResult = result {
                    self.shoppingItems[indexPath.row] = okResult
                    self.tableView.reloadData()
                    self.saveList()
                }
            }
        })
    }
    
    //右滑出現刪除功能，刪除後重新更新TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingItems.remove(at: indexPath.row)
            saveList()
            tableView.reloadData()
        }
    }
    
  

}

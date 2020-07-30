//
//  yesterdayViewController.swift
//  Watercharger
//
//  Created by 平良悠貴 on 2020/07/28.
//  Copyright © 2020 平良悠貴. All rights reserved.
//
import UIKit
import WaveAnimationView
import Vision
import Realm
import RealmSwift

class yesterdayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //    var panGR : UIPanGestureRecognizer!
    var customCell : [itemDetail] = []
    var wave : WaveAnimationView!
    var waveParsent :Float!
    var parsentCalc :Int = 0
    var sum_water : Float = 0
    
    let yesterday = Calendar(identifier: .gregorian).date(byAdding: .day, value: -1, to: Date())
    var serch_result :Results<itemDetail>!
    var serch_result_count : Int = 0
    var resultArray : Array<String> = []
    
    @IBOutlet var lapView : UIView!
    @IBOutlet weak var parsent: UILabel!
    @IBOutlet weak var tableView: UITableView!
    fileprivate let refreshCtl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "customTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 80.0
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.blue
        customCell = itemDetail.loadAll()
        tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        wave = WaveAnimationView(frame: CGRect(origin: .zero, size: lapView.bounds.size), color: UIColor.blue.withAlphaComponent(0.5))
        lapView.addSubview(wave)
        wave.maskImage = UIImage(named: "水滴アイコン4.png")
        wave.startAnimation()
        serch()
        sumWater()
        waveCalc()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        serch()
        sumWater()
        waveCalc()
        loadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        // ここが引っ張られるたびに呼び出される
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        loadData()
        sender.endRefreshing()
    }
    
    func waveCalc(){
        waveParsent = sum_water/5000
        wave.progress = waveParsent
        parsentCalc = Int(waveParsent * 100)
        parsent.text = String(parsentCalc)+"%"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if serch_result_count == nil {
            return 0
        } else {
            return serch_result_count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customTableViewCell
        let object = serch_result[indexPath.row]
        
        
        cell.time.text = object.time
        cell.bariation.text = object.title
        cell.ryou.text = object.bottle
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        
        return stringFromDate(date: yesterday!, format: "M月dd日")
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 24)
        label.text = stringFromDate(date: yesterday!, format: "M月dd日")
        return label
    }
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    private func loadData(){
        customCell = itemDetail.loadAll()
        tableView.reloadData()
    }
    func serch(){
        let day = stringFromDate(date: yesterday!, format: "M月dd日")
        let predicate = NSPredicate("month", contains: day)
        let serch = try!Realm().objects(itemDetail.self).filter(predicate).sorted(byKeyPath: "time", ascending: false)
        serch_result = serch
        serch_result_count = serch.count
        print(serch_result_count)
    }
    func sumWater(){
        sum_water = 0
        for i in 0..<serch_result_count {
            let mll = Float(serch_result[i].bottle)!
            sum_water = mll + sum_water
        }
    }
    //MARK:遷移コード
    @IBAction func toEureka(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title:"", message: "測定するにはどうしますか？", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "カメラで入力", style: .default) { (UIAlertAction) in
            let cameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "eureka_camera") as! eurekaViewController
            self.navigationController?.show(cameraViewController, sender: nil)
            print("camera")
        }
        
        let hand = UIAlertAction(title: "手動で入力", style: .default) { (UIAlertAction) in
            let handViewController = self.storyboard?.instantiateViewController(withIdentifier: "eureka_hand") as! eurekaHandViewController
            self.navigationController?.show(handViewController, sender: nil)
            print("hand")
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
            print("cansel")
        }
        alert.addAction(camera)
        alert.addAction(hand)
        alert.addAction(cancel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2,
                                                                     y: screenSize.size.height,
                                                                     width: 0,
                                                                     height: 0)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let alert = UIAlertController(title: "注意", message: "削除してよろしいですか？", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if(editingStyle == UITableViewCell.EditingStyle.delete) {
                // Realm内のデータを削除
                do{
                    let realm = try Realm()
                    try realm.write {
                        realm.delete(self.customCell[indexPath.row])
                    }
                    print(self.serch_result[indexPath.row])
                    self.customCell.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with:UITableView.RowAnimation.fade)
                    
                    self.tableView.reloadData()
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            // セルの高さを設定
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                tableView.estimatedRowHeight = 100
                return UITableView.automaticDimension
            }
            alert.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel){
            (action) -> Void in
            
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

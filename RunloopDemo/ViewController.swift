//
//  ViewController.swift
//  RunloopDemo
//
//  Created by Quan Li on 2020/12/16.
//

import UIKit



class ViewController: UIViewController {

    var resident = ResidentMemoryThread.init()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func runTask(_ sender: Any) {
        resident.runTask {
            print("当前线程\(Thread.current)")
        }
    }
    
    @IBAction func cancelTask(_ sender: Any) {
        resident.cancelTask()
    }
}


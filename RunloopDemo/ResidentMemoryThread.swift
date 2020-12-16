//
//  ResidentMemoryThread.swift
//  RunloopDemo
//
//  Created by Quan Li on 2020/12/16.
//

import Foundation


fileprivate class MyThread:Thread{
    deinit {
        print("MyThread 销毁了")
    }
}

class ResidentMemoryThread :NSObject{
    private var thread:MyThread?
    private var isStop = false
    
    override init(){
        super.init()
        thread = MyThread.init(block: {[unowned self] in
            autoreleasepool { () -> Void in
                RunLoop.current.add(Port.init(), forMode: .default)
                while !self.isStop && RunLoop.current.run(mode: .default, before: .distantFuture) {}
                print("Runloop 退出")
            }
        })
        thread?.name = "常驻线程"
        thread?.start()
    }
    
    func runTask(_ task:@convention(block) @escaping () ->()){
        guard let thread = self.thread else {
            return
        }
        perform(#selector(performRunTask(_:)), on: thread, with: task, waitUntilDone: false)
    }
    
    func cancelTask(){
        guard let thread = self.thread else {
            return
        }
        perform(#selector(performStopTask), on: thread, with: nil, waitUntilDone: false)
    }
    
    @objc private func performRunTask(_ task:@convention(block) @escaping () ->()){
        task()
    }
    
    
    @objc  private func performStopTask(){
        isStop = true
        CFRunLoopStop(CFRunLoopGetCurrent())
        thread = nil
    }
    
    deinit {
        print("ResidentMemoryThread 销毁了")
    }
}


//
//  CommentViewModel.swift
//  Microduino
//
//  Created by harvey on 16/4/13.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit
import Alamofire
import SwiftDDP

class CommentViewModel: NSObject {

    //文章列表
    private weak var commentTable : UITableView!
    
    //最新文章
    var newDataSource : Array<CommentModel> = Array()
    // 回调
    typealias CommentViewModelSuccessCallBack = (dataSoure : Array<CommentModel>) -> Void
    typealias CommentVieModelErrorCallBack = (error : NSError) -> Void
    var successCallBack : CommentViewModelSuccessCallBack?
    var errorCallBack : CommentVieModelErrorCallBack?
    
    convenience init(commentTable : UITableView) {
        
        self.init()
        self.commentTable = commentTable
    }
    
    func initCommentData(result:NSMutableArray){
    
        self.newDataSource.removeAll()
        for dict in result {
            let commentModel : CommentModel = CommentModel(dict: dict as! NSDictionary)
            self.newDataSource.append(commentModel)
            self.commentTable.reloadData()
            
        }
    }
    
}
//
//  YPGlobalPopupManager.swift
//  yappu-world-ios
//
//  Created by Tabber on 5/4/25.
//

import Foundation
import SwiftUI

struct YPGlobalPopupData: Identifiable {
    let id = UUID()
    let title: String
    let message: String?
    let confirmTitle: String
    let cancelTitle: String?
    let buttonAxis: Axis
}

@Observable
class YPGlobalPopupManager {
    
    var currentPopup: YPGlobalPopupData?
    var isPresented: Bool
    
    static var shared = YPGlobalPopupManager()
    
    init() {
        isPresented = false
    }
    
    func show(title: String = "앗! 예기치 못한 오류가 발생했어요.", message: String = """
재시도 후에도 같은 문제가 발생한다면, 
개발팀에 제보해주세요! 
서비스 품질 향상에 큰 도움이 됩니다 :) 
""", confirmTitle: String = "제보하러 가기", cancelTitle: String? = "닫기", buttonAxis: Axis = .vertical) {
        
        let data = YPGlobalPopupData(title: title, message: message, confirmTitle: confirmTitle, cancelTitle: cancelTitle, buttonAxis: buttonAxis)
        currentPopup = data
        withAnimation(.smooth) {
            isPresented = true
        }
    }
    
    func dismiss() {
        withAnimation(.smooth) {
            isPresented = false
        }
    }
}

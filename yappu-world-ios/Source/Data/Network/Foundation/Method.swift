//
//  JHRequest.swift
//  todayMovie
//
//  Created by 한상진 on 11/20/23.
//

import Foundation

public typealias Parameters = [String: Any]

extension Parameters {
    static func makeParameters(_ model: Any) -> Parameters {
        let result = convert(model)
        // 결과가 배열이라면, top-level 배열를 특정 키("data") 아래에 래핑
        if let array = result as? [Any] {
            return ["data": array]
        }
        
        return result as? Parameters ?? [:]
    }
    
    /// 재귀적으로 모델을 변환하여, JSON 직렬화 가능한 객체(딕셔너리, 배열, 기본타입 등)로 만듭니다.
    private static func convert(_ model: Any) -> Any {
        let mirror = Mirror(reflecting: model)
        // Optional 처리: 값이 있으면 내부 값을 재귀 변환, 없으면 NSNull 반환
        if mirror.displayStyle == .optional {
            guard let firstChild = mirror.children.first else {
                return NSNull()
            }
            return convert(firstChild.value)
        }
        
        // 배열(컬렉션) 처리: 배열 내부의 각 요소를 재귀 변환하여 실제 배열(\[Any\])로 반환
        if mirror.displayStyle == .collection {
            var resultArray: [Any] = []
            for child in mirror.children {
                resultArray.append(convert(child.value))
            }
            return resultArray
        }
        
        // 딕셔너리 처리: 각 (key, value) 쌍을 재귀 변환하여 [String: Any]로 반환
        if mirror.displayStyle == .dictionary {
            var resultDict: [String: Any] = [:]
            for child in mirror.children {
                // 딕셔너리의 각 자식은 (key, value) 튜플입니다.
                let pairMirror = Mirror(reflecting: child.value)
                let pairChildren = Array(pairMirror.children)
                guard
                    pairMirror.children.count == 2,
                    let key = pairChildren.first?.value as? String,
                    let value = pairChildren.last?.value
                else { continue }
                resultDict[key] = convert(value)
            }
            return resultDict
        }
        
        // 커스텀 타입(구조체, 클래스 등) 처리: 자식 프로퍼티가 있으면 [String: Any] 딕셔너리로 변환
        if !mirror.children.isEmpty {
            var resultDict: [String: Any] = [:]
            for child in mirror.children {
                guard let label = child.label else { continue }
                resultDict[label] = convert(child.value)
            }
            return resultDict
        }
        
        // 기본 타입(String, Number, Bool 등)은 그대로 반환
        return model
    }
}

@frozen public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

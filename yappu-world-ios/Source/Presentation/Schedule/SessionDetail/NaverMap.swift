//
//  NaverMap.swift
//  yappu-world-ios
//
//  Created by 김건형 on 10/5/25.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable {
    var latitude: Double
    var longitude: Double
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = context.coordinator.getNaverMapView()
        context.coordinator.setMarker(lat: latitude, lng: longitude)
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
}

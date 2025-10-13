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
        Coordinator()
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = context.coordinator.mapView
        context.coordinator.configureDefaults()
        context.coordinator.updateMarker(lat: latitude, lng: longitude)
        
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        context.coordinator.updateMarker(lat: latitude, lng: longitude)
    }
    
    final class Coordinator: NSObject,
                             NMFMapViewCameraDelegate,
                             NMFMapViewTouchDelegate,
                             CLLocationManagerDelegate {
        
        let mapView = NMFNaverMapView(frame: .zero)
        private let marker = NMFMarker()
        
        // 지도 기본 설정
        func configureDefaults() {
            mapView.mapView.isNightModeEnabled = true
            mapView.mapView.zoomLevel = 15
            mapView.mapView.minZoomLevel = 1
            mapView.mapView.maxZoomLevel = 17
            
            mapView.showZoomControls = true // 줌 버튼: 탭하면 지도의 줌 레벨을 1씩 증가 또는 감소
            mapView.showScaleBar = false // 스케일 바: 지도의 축척을 표현합니다. 지도를 조작하는 기능
            //        mapView.showLocationButton = true // 현위치 버튼: 위치 추적 모드를 표현합니다. 탭하면 모드가 변경
            //        mapView.showCompass = true //  나침반 : 카메라의 회전 및 틸트 상태를 표현합니다. 탭하면 카메라의 헤딩과 틸트가 0으로 초기화됩니다. 헤딩과 틸트가 0이 되면 자동으로 사라짐

            marker.mapView = mapView.mapView
        }
        
        func updateMarker(lat: Double, lng: Double, zoom: Double = 15) {
            marker.position = NMGLatLng(lat: lat, lng: lng)
            marker.mapView = mapView.mapView

            let cam = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: zoom)
            cam.animation = .easeIn
            cam.animationDuration = 1
            mapView.mapView.moveCamera(cam)
        }
    }
}

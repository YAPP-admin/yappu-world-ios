//
//  Coordinator.swift
//  yappu-world-ios
//
//  Created by 김건형 on 10/5/25.
//

import UIKit
import NMapsMap

// - NMFMapViewCameraDelegate 카메라 이동에 필요한 델리게이트,
// - NMFMapViewTouchDelegate 맵 터치할 때 필요한 델리게이트,
// - CLLocationManagerDelegate 위치 관련해서 필요한 델리게이트

class Coordinator: NSObject, ObservableObject,
                   NMFMapViewCameraDelegate,
                   NMFMapViewTouchDelegate,
                   CLLocationManagerDelegate {
    static let shared = Coordinator()
    
    @Published var coord: (Double, Double) = (0.0, 0.0)
    @Published var userLocation: (Double, Double) = (0.0, 0.0)
    
    var locationManager: CLLocationManager?
    let startInfoWindow = NMFInfoWindow()
    
    let view = NMFNaverMapView(frame: .zero)
    
    override init() {
        super.init()
        
        // 지도 기본 설정
        view.mapView.isNightModeEnabled = true
        view.mapView.zoomLevel = 15
        view.mapView.minZoomLevel = 1
        view.mapView.maxZoomLevel = 17
        
        view.showZoomControls = false // 줌 버튼: 탭하면 지도의 줌 레벨을 1씩 증가 또는 감소합니다.
        view.showScaleBar = false // 스케일 바 : 지도의 축척을 표현합니다. 지도를 조작하는 기능은 없습니다.
//        view.showLocationButton = true // 현위치 버튼: 위치 추적 모드를 표현합니다. 탭하면 모드가 변경됩니다.
//        view.showCompass = true //  나침반 : 카메라의 회전 및 틸트 상태를 표현합니다. 탭하면 카메라의 헤딩과 틸트가 0으로 초기화됩니다. 헤딩과 틸트가 0이 되면 자동으로 사라집니다
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라 이동이 시작되기 전 호출되는 함수
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 카메라의 위치가 변경되면 호출되는 함수
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    // MARK: - 마커 위치를 중심으로 지도 설정
    private func moveCameraToMarker(lat: Double, lng: Double, zoom: Double = 15) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: zoom)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        view.mapView.moveCamera(cameraUpdate)
    }

    // 마커 위치 설정 및 카메라 이동
    func setMarker(lat: Double, lng: Double, zoom: Double = 15) {
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_PINK
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = view.mapView
        
        // 마커 위치로 카메라 이동
        moveCameraToMarker(lat: lat, lng: lng, zoom: zoom)
    }
}

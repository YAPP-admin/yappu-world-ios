//
//  HomeView.swift
//  yappu-world-ios
//
//  Created by Tabber on 1/6/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        VStack {
            HStack {
                Image("yapp_logo")
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image("setting_icon")
                })
            }
            
            
            ScrollView {
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)    .foregroundStyle(.white)
                        
                        Text("Test")
                            .padding(.vertical, 30)
                    }
                    .padding(.top, 16)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)    .foregroundStyle(.white)
                        VStack(alignment: .leading) {
                            HStack {
                               Text("공지사항")
                                    .font(.pretendard18(.semibold))
                            }
                            
                            VStack {
                                ForEach(0...2, id: \.self) { idx in
                                    NoticeCell()
                                    
                                    if idx != 2 {
                                        Divider()
                                    }
                                    
                                }
                            }
                        }
                        .padding(.all, 16)
                    }
                }
                
            }
        }
        .padding(.horizontal, 20)
        .background(Color.mainBackgroundNormal.ignoresSafeArea())
    }
}

#Preview {
    HomeView()
}

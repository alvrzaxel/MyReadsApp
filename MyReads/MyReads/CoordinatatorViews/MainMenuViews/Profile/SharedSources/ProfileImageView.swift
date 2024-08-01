//
//  ProfileImageView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 26/7/24.
//

import SwiftUI
import PhotosUI

struct ProfileImageView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var show: Bool = false
    @State var selectedItem: PhotosPickerItem? = nil
    @State var profileImage: UIImage? = nil
    @State var showPicker: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                ZStack(alignment: show ? .leading : .center) {
                    if let profileImage = profileImage {
                        ProfileImageView2(show: $show, profileImage: profileImage)
                    } else {
                        UserEmptyImageView()
                    }
                    nameView(show: $show)
                }
                
            }
            //.ignoresSafeArea()
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        
        .overlay(alignment: .topTrailing) {
            Button(action: {
                showPicker.toggle()
            }) {
                Image(systemName: "photo")
                    .frame(width: 23, height: 23)
                    .padding(10)
                    .background(.backgroundGeneral, in: .circle)
                    .foregroundStyle(.customOrange4)

            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                }
            }
        }
    }
}



struct ProfileImageView2: View {
    @Binding var show: Bool
    var profileImage: UIImage
    var body: some View {
        GeometryReader(content: { geo in
            Image(uiImage: profileImage).resizable().scaledToFill()
                .frame(width: show ? geo.size.width : 110, height: show ? 320 : 110)
                .clipShape(.rect(cornerRadius: show ? 0: 100))
                .padding(.top, show ? 0 : 100)
                .onTapGesture {
                    withAnimation {
                        show.toggle()
                    }
                    
                }
        })
        .frame(maxWidth: show ? .infinity : 110, maxHeight: show ? 240 : 210)
    }
}

struct nameView:View {
    @Binding var show: Bool
    var body: some View {
        VStack {
            Text("Axel").bold()
                .font(.largeTitle)
                .foregroundStyle(show ? .white : .authenticationTitle2)
        }
        .offset(y: show ? 155 : 159)
        .padding(.leading, show ? 24 : 0)
    }
}

struct CButton:View {
    var icon: ImageResource
    var action: () -> Void
    var body: some View {
        Button(action: {action()}, label: {
            Image(icon).resizable()
                .scaledToFit()
                .frame(width: 23, height: 23)
                .padding(10)
                .background(.authenticationEye, in: Circle())
                .overlay {
                    Circle().stroke(lineWidth: 1)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing))
                }
        })
    }
}
#Preview {
    ProfileImageView(userProfileViewModel: UserProfileViewModel())
}

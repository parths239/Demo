///
//  BodySqueezeView.swift
//  Lifestages Align
//
//  Created by Jason Yu on 8/3/24.
//

import SwiftUI
import Combine

struct BodySqueezeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var progress: CGFloat = 0
    @State private var timer : Timer.TimerPublisher = Timer.publish(every: 0.02, on: .main, in: .common)
    @State private var timerActive = false
    @State private var secondsRemaining = 300
    
    // Timer Management
    private func startTimer() {
        timer = Timer.publish(every: 0.02, on: .main, in: .common)
        timerActive = true
        _ = timer.connect().store(in: &cancellables)
    }
    
    private func stopTimer(){
        timerActive = false
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func resetTimer(){
        progress = 0
        secondsRemaining = 300
    }
    
    func timeString(time: Int) -> String{
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack{
            BodySqueezeHeader(showAccountSettings: .constant(false))
                .environmentObject(CurrentUserViewModel())
            
            HStack{
                Image("left_arrow")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.leading, 20)
                
                Spacer()
                
                Text("Body Scan Squeeze")
                    .font(.custom("Horison", size: 24))
                
                Spacer()
            }
            
            //.padding(.vertical, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: 31)
                    .fill(Color(hex : "#F1E1CE"))
                    .frame(width: 380, height: 166)
                    .overlay(
                        RoundedRectangle(cornerRadius: 31)
                            .stroke(Color(hex : "#000000"), lineWidth: 1)
                    )
                    .padding(.horizontal, 12)
                
                
                Image("BodySqueeze")
                    .resizable()
                    .frame(width: 145, height: 140)
                    .padding(.horizontal, 143)
            }
            Spacer()
            
            Text("Take a moment to shake into yourself. Get comfotable in your body and close your eyes.")
                .font(.custom("Big Caslon FB", size: 22))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 38)
            
            Spacer()
            Spacer()
            
            ZStack{
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.6)
                    .foregroundColor(Color(hex : "#F1E1CE"))
                    .frame(width: 160, height: 160)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .foregroundColor(Color(hex: "#44614D"))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: progress)
                
                Text("\(timeString(time: secondsRemaining))")
                    .font(.custom("Horison", size: 25))
                    .foregroundColor(Color(hex: "#3E431B"))
            }
            .onAppear{
                startTimer()
            }
            .onReceive(timer){ _ in
                if progress < 1 {
                    progress += 0.02 / 300
                    secondsRemaining = 300 - Int(progress * 300)
                } else {
                    stopTimer()
                }
            }
            
            Spacer()
            
            Button(action: {
                if timerActive{
                    stopTimer()
                } else {
                    startTimer()
                }
            }){
                Image(systemName: timerActive ? "pause.fill" : "play.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "#44614D"))
                    .clipShape(Circle())
                    .frame(width: 56, height: 56)
            }
        }
        .background {
            Color("eggshell")
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct BodySqueezeHeader: View{
    @EnvironmentObject var currentUser : CurrentUserViewModel
    
    @Binding var showAccountSettings : Bool
    
    var body: some View {
        VStack{
            
            HStack{
                Image("align_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height : 57)
                
                
                Spacer()
                
                HStack(spacing : 12) {
                    Button {
                        
                    } label: {
                        Image(systemName: "bell")
                            //.resizable()
                            //.frame(width : 30, height: 30)
                            .foregroundColor(.black.opacity(0.6))
                            .overlay {
                                Circle()
                                    .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1)
                            }
                    }
                    
                    Button(action: {
                        showAccountSettings = true
                    }, label: {
                        ProfilePhotoOrInitials(profileImage: currentUser.user.profileImage, fullName: "\(currentUser.user.firstName) \(currentUser.user.lastName)", radius: 40, fontSize: 16)
                    })
                }
            }
            
            HStack{
                Image("align_tagline2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 127, height: 34)
                Spacer()
            }
        }
        
        .padding(.horizontal)
    }
}



#Preview {
    BodySqueezeView()
        .environmentObject(CurrentUserViewModel())
}

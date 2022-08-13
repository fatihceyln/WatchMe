//
//  ReferenceDetailView.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import SwiftUI

struct ReferenceDetailView: View {
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 225)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Thor: Love and Thunder")
                        .font(.system(size: 20))
                        .fontWeight(.heavy)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("07/08/2022")
                        }
                        
                        HStack {
                            Image(systemName: "film")
                            
                            Text("Action, Adventure, Fantasy")
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                            
                            Text("1h 59m")
                        }
                    }
                    .padding(.top, 30)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Text("After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Mighty Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal)
            
            Text("Top Billed Cast")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<10) { _ in
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 150, height: 225)
                            VStack(alignment: .leading) {
                                Text("Chris Hemsworth")
                                    .bold()
                                
                                Text("Thor odinson")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Text("Similar Movies")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<10) { _ in
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 150, height: 225)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ReferenceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReferenceDetailView()
            .preferredColorScheme(.dark)
    }
}

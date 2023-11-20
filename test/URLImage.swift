//
//  CircleImage.swift
//  test
//
//  Created by Qiu, Men Seng on 20.11.23.
//

import SwiftUI

struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay{
                                Circle().stroke(.white, lineWidth: 4)
                            }
                            .shadow(radius: 7)
        } else {
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .background()
                .onAppear{
                    data = fetchImage(url: urlString)
                }
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay{
                                Circle().stroke(.white, lineWidth: 4)
                            }
                            .shadow(radius: 7)
        }
    }
}

private func fetchImage(url: String) -> Data?{
    var ret: Data?
    guard let url = URL(string: url) else {
        return nil
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
        ret = data
    }
    
    task.resume()
    return ret
}

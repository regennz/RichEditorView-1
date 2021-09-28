//
//  ContentView.swift
//  ExampleRichEditorView-SwiftUI
//
//  Created by Hung on 29/09/2021.
//

import SwiftUI

struct ContentView: View {
    @State var text = "What I'll usually do for focus and unfocus is similar to what Google Docs does. The insert link functionality is similar to Reddit's except I use a UIAlertController. There are some added and altered functionality like running your custom JS; you will just have to learn what goes on with this package, but it's a quick learn. <b>Good luck!</b> If you have any issues, Yoom will help out, so long as those issues are opened in this repo. Credits still go out to cjwirth and C. Bess"
    @State var isEditing = false
    @State var richTextEditorHeight: CGFloat = 80
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if isEditing {
                Text("Is editing...").onTapGesture {
                    UIApplication.shared.endEditing()
                }
            } else {
                Text("Not editing...").onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
      
            RichTextEditor(text: $text, isEditing: $isEditing, placeholder: "This is placeholder")
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//
//  ContentView.swift
//  baseQuick
//
//  Created by wangzicheng on 2025/8/19.
//

import SwiftUI

struct ContentView: View {
    @State private var input: String = ""
    @State private var output: String = ""
    @State private var copiedWhich: CopiedWhich = .none
    @State private var copiedTime: Int = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            ZStack(alignment: .top) {
                Color.blue.opacity(colorScheme == .dark ? 0.15 : 0.05)
                if copiedWhich == .normal {
                    Color.indigo.opacity(0.1 + CGFloat(copiedTime % 3) * 0.1)
                }
                Button {
                    UIPasteboard.general.string = input
                    withAnimation {
                        copiedTime += 1
                        copiedWhich = .normal
                    }
                } label: {
                    copyButton(which: .normal)
                }
                
                TextField(text: $input, axis: .vertical) {
                    Text("input normal text...")
                        .foregroundStyle(Color.gray.opacity(0.5))
                }
                .textFieldStyle(.roundedBorder)
                .navigationTitle("normal")
                .offset(y: 80)
                .padding(.horizontal, 8)
            }
            .cornerRadius(8)
            
            Rectangle()
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .foregroundStyle(Color.gray.opacity(0.1))
            
            ZStack(alignment: .top) {
                Color.blue.opacity(colorScheme == .dark ? 0.2 : 0.1)
                if copiedWhich == .base64 {
                    Color.cyan.opacity(0.1 + CGFloat(copiedTime % 3) * 0.1)
                }
                Button {
                    UIPasteboard.general.string = output
                    withAnimation {
                        copiedTime += 1
                        copiedWhich = .base64
                    }
                } label: {
                    copyButton(which: .base64)
                }
                
                TextField(text: $output, axis: .vertical) {
                    Text("input base64 text...")
                        .foregroundStyle(Color.gray.opacity(0.5))
                }
                .textFieldStyle(.roundedBorder)
                .navigationTitle("base64")
                .offset(y: 80)
                .padding(.horizontal, 8)
            }
            .cornerRadius(8)
        }
        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
        .font(.system(size: 16, weight: .medium))
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
        .padding(.vertical, 24)
        .onChange(of: input) { newStr in
            let newOut = input.toBase64()
            if newOut != output {
                withAnimation {
                    output = newOut
                }
            }
        }
        .onChange(of: output) { newStr in
            if let newOut = newStr.fromBase64() {
                if newOut != input {
                    withAnimation {
                        input = newOut
                    }
                }
            }

        }
    }
    
    @ViewBuilder
    private func copyButton(which: CopiedWhich) -> some View {
        Text(verbatim: which.text)
            .foregroundStyle(Color.blue)
            .font(.system(size: 18, weight: .bold))
            .padding(16)
            .padding(.top, 16)
    }

}

enum CopiedWhich {
    case normal
    case base64
    case none
    
    var text: String {
        switch self {
        case .base64:
            "Copy base64"
        case .normal:
            "Copy normal"
        case .none:
            ""
        }
    }
}

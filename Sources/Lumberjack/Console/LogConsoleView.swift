//
//  LogConsoleView.swift
//  Lumberjack
//
//  Created by Mitch Treece on 6/21/23.
//

//import SwiftUI
//
//public struct LogConsoleView: View {
//    
//    @Environment(\.dismiss) private var dismiss
//    
//    public var body: some View {
//        
//        NavigationView {
//            
//            List {
//                
//                ForEach(1..<11) { i in
//                    Text("Dummy Log #\(i)")
//                }
//                
//            }
//            .navigationTitle("Console")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//
//                ToolbarItem(placement: .topBarLeading) {
//                    
//                    ToolbarItemView {
//                        
//                        Menu {
//                            
//                            ForEach(LogLevel.allCases) { level in
//                                
//                                Button {
//                                    
//                                    self.filter([level])
//     
//                                } label: {
//                                    
//                                    Label(
//                                        level.name.capitalized,
//                                        systemImage: level.systemImageName
//                                    )
//                                    
//                                }
//                                                                
//                            }
//                            
//                            Button {
//                                
//                                self.filter(LogLevel.allCases)
// 
//                            } label: {
//                                
//                                Label(
//                                    "All",
//                                    systemImage: "line.horizontal.3.circle"
//                                )
//                                
//                            }
//                            
//                        } label: {
//                            
//                            Image(systemName: "line.horizontal.3.decrease")
//                            
//                        }
//                        
//                    }
//                    .tint(.black)
//                    
//                }
//                
//                ToolbarItem(placement: .topBarTrailing) {
//                    
//                    ToolbarItemView {
//                        
//                        Button {
//                            
//                            dismiss()
//                            
//                        } label: {
//                            
//                            Image(systemName: "xmark.circle.fill")
//                            
//                        }
//                        
//                    }
//                    .tint(.black.opacity(0.3))
//                    
//                }
//                
//            }
//            
//        }
//        
//    }
//    
//    private func filter(_ levels: [LogLevel]) {
//        
//    }
//    
//    private func resetFilters() {
//        
//    }
//    
//}

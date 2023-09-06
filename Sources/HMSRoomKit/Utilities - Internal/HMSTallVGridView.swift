//
//  HMSTallVGridView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 19/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct TallVGrid<Item, ItemView, I>: View where ItemView: View, I: Hashable {
    var items: [Item]
    var idKeyPath: KeyPath<Item, I>
    var numOfItems : Int {
        return isTrailing ? maxItemInOnePage : items.count
    }
    var numOfColumns : Int = 2
    var vhSpacing: CGFloat
    var isTrailing = false
    let maxItemInOnePage: Int
    @ViewBuilder var content: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { g in
            let columns = Array(repeating: GridItem(.flexible(minimum: 0, maximum: g.size.width)), count: numOfColumns)
            let numOfRows: Int = Int(ceil(Double(numOfItems) / Double(numOfColumns)))
            let height: CGFloat = (g.size.height - (vhSpacing * CGFloat(numOfRows - 1))) / CGFloat(numOfRows)
            
            let width: CGFloat = (g.size.width - (vhSpacing * CGFloat(numOfColumns - 1))) / CGFloat(numOfColumns)
            
            if numOfItems == 5 || numOfItems == 1 {
                VStack {
                    LazyVGrid(columns: columns, alignment: .center, spacing: vhSpacing) {
                        ForEach(items.dropLast(items.count % numOfColumns), id: idKeyPath) { item in
                            VStack {
                                content(item)
                            }
                            .frame(minHeight: height, maxHeight: .infinity)
                            .frame(minWidth: width, maxWidth: .infinity)
                        }
                    }
                    
                    LazyHStack {
                        ForEach(items.suffix(items.count % numOfColumns), id: idKeyPath) { item in
                            VStack {
                                content(item)
                            }
                            .frame(minHeight: height, maxHeight: .infinity)
                            .frame(minWidth: width, maxWidth: .infinity)
                        }
                    }
                }
            }
            else {
                LazyVGrid(columns: columns, alignment: .leading, spacing: vhSpacing) {
                    ForEach(items, id: idKeyPath) { item in
                        VStack {
                            content(item)
                        }
                        .frame(minHeight: height, maxHeight: .infinity)
                        .frame(minWidth: width, maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

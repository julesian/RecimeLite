//
//  HomeView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//


import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Recipes")
                }
            
            PlanView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Plan")
                }
            
            GroceryView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Grocery")
                }
            
            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis.circle")
                    Text("More")
                }
        }
    }
}
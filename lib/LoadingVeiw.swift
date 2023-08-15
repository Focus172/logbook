//
//  LoadingVeiw.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/11/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import SwiftUI

struct LoadingView: View {
  
  
  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: 50, height: 50)
      
      LoadingView()
    }
  }
}

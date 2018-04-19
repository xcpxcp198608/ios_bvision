//
//  BMCustomPlayer.swift
//  blive
//
//  Created by patrick on 08/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit
import BMPlayer

class BMCustomPlayer: BMPlayer {
    class override func storyBoardCustomControl() -> BMPlayerControlView? {
        return BMPlayerCustomControlView()
    }
}

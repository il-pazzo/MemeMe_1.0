//
//  Meme.swift
//  MemeMe
//
//  Created by Glenn Cole on 5/19/19.
//  Copyright © 2019 Glenn Cole. All rights reserved.
//

import Foundation
import UIKit

struct Meme
{
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage?
}

extension Meme: CustomStringConvertible
{
    var description: String {
        return "top=\(topText ?? "-"), bot=\(bottomText ?? "-"), origImage=\(originalImage == nil ? "-" : "present"), memeImage=\(memedImage == nil ? "-" : "present")"
    }
}


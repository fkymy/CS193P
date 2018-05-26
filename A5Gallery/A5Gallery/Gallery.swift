//
//  Gallery.swift
//  A5Gallery
//
//  Created by Yuske Fukuyama on 2018/03/29.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation
import UIKit

class Gallery {
    var name: String = ""
    var images: [Image] = []

    struct Image: Equatable, Hashable {
        // Image model is essentially just a url with
        // functionality of massaging url and calculating aspect ratios

        var url: URL?
        weak var image: UIImage?
        
        var aspectRatio: CGFloat {
            return image != nil ? image!.size.width / image!.size.height : 1.0
        }
        
        private static var identifierFactory = 0
        let hashValue: Int = {
            identifierFactory += 1
            return identifierFactory
        }()
        
        static func ==(lhs: Gallery.Image, rhs: Gallery.Image) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
}

extension Gallery: CustomStringConvertible {
    var description: String {
        var returnString = ""
        returnString += "Gallery: \"\(name)\"\n"
        for index in images.indices {
            if let url = images[index].url {
                returnString += "index \(index): \(url)\n"
            } else {
                returnString += "index \(index): no url\n"
            }
        }
        return returnString
    }
}

extension Gallery.Image: CustomStringConvertible {
    var description: String {
        if let url = url {
            return "Gallery.Image: \"\(url)\""
        } else {
            return "Gallery.Image: no url"
        }
    }
}

//class Gallery: CustomStringConvertible {
//    var name: String
//    var images: [GalleryImage]
//    // private static var identifierFactory = 0
//    // var identifier = {
//    //     identifierFactory += 1
//    //     return identifierFactory
//    // }()
//
//    init(name: String) {
//        self.name = name
//        self.images = []
//        if let urls = DefaultGalleryData.data[name] {
//            for url in urls {
//                self.images.append(GalleryImage(with: url))
//            }
//        }
//    }
//
//    var description: String {
//        var returnString = ""
//        returnString += "Gallery: \"\(self.name)\"\n"
//        for index in self.images.indices {
//            if let url = self.images[index].url {
//                returnString += "index \(index): \(String(describing: url))\n"
//            } else {
//                returnString += "index \(index): no url\n"
//            }
//        }
//        return returnString
//    }
//}
//
//struct GalleryImage: CustomStringConvertible {
//    // GalleryImage model is essentially just a url with
//    // functionality of massaging url and calculating aspect ratios
//
//    var url: URL?
//    weak var image: UIImage?
//
//    var aspectRatio: CGFloat {
//        return image != nil ? image!.size.height / image!.size.width : 1.0
//    }
//
//    init(with url: URL) {
//        self.url = url.imageURL
//    }
//
//    var description: String {
//        return "GalleryImage: \"\(String(describing: url))\", image: \(String(describing: image))\n"
//    }
//}
//
//struct DefaultGalleryData {
//    static var data: Dictionary<String,Array<URL>> = {
//        let URLStrings = [
//            "Animals" : [
//                "http://r.ddmcdn.com/w_830/s_f/o_1/cx_98/cy_0/cw_640/ch_360/APL/uploads/2015/07/cecil-AP463227356214-1000x400.jpg",
//                "http://animals.sandiegozoo.org/sites/default/files/2016-09/animals_hero_panda.jpg",
//                "https://www.nationalgeographic.com/content/dam/photography/rights-exempt/best-of-photo-of-the-day/2017/animals/01_pod-best-animals.jpg",
//                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrHhiR69SpHTO3Az7RyEnsIEYn2YK_ocO9UZ8nAXM1EZVcRsCB",
//                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZVS0-ZizbrWW1oEd1k5ahXBFgrxU5UxA916ysYbxMd1I4vY7ZFA"
//            ],
//            "Powerlines": [
//                "http://www.ox.ac.uk/sites/files/oxford/styles/ow_medium_feature/public/field/field_image_main/Powerlines.jpg?itok=C6qp6Q2x",
//                "https://thumbor.forbes.com/thumbor/960x0/smart/https%3A%2F%2Fblogs-images.forbes.com%2Fstevensalzberg%2Ffiles%2F2014%2F08%2F670px-power_lines.jpg",
//                "http://news.ufl.edu/media/newsufledu/images/2017/09/Power-Lines.jpg",
//                "https://www.fae-group.com/images/applicazioni/header/Applications_power_lines_fae.jpg",
//                "https://i.pinimg.com/736x/25/e5/a0/25e5a01fbbd8a0b78048c01c8dfe2906.jpg"
//            ],
//            "Gophers": [
//                "https://blog.newrelic.com/wp-content/uploads/golang-gopher.jpg",
//                "https://cdn-images-1.medium.com/max/607/0*fyyS1OHEaQ2il8Tg.png",
//                "https://i.pinimg.com/originals/6d/59/e0/6d59e040d319ed8ee34db1dc5c313c2f.png",
//                "https://cms-assets.tutsplus.com/uploads/users/71/courses/977/preview_image/GO-3.png",
//                "http://static.cynere.com/uploads/537009a8ba8242578d0a5fbc21a24f48.jpg"
//            ]
//        ]
//
//        var dict = Dictionary<String,Array<URL>>()
//        for (key, value) in URLStrings {
//            dict[key] = value.map { URL(string: $0)! }
//        }
//        return dict
//    }()
//}

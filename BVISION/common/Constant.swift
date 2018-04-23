//
//  Constant.swift
//  blive
//
//  Created by patrick on 16/12/2017.
//  Copyright © 2017 许程鹏. All rights reserved.
//

import Foundation
import Alamofire

struct Constant {
    
    static let base_url = "https://blive.bvision.live/"
    
    
    static let url_channel = "\(base_url)channel/"
    static let url_channel_living = "\(base_url)channel/living"
    static let url_channel_search = "\(base_url)channel/search/"
    static let url_channel_update_all_info = "\(base_url)channel/update/0"
    static let url_channel_update_status = "\(base_url)channel/status/"
    static let url_channel_upload_preview = "\(base_url)channel/upload/"
    
    static let url_user_signin = "\(base_url)user/signin"
    static let url_user_signup = "\(base_url)user/signup"
    static let url_user_reset = "\(base_url)user/reset"
    static let url_user_update_pw = "\(base_url)user/update/"
    static let url_user_details = "\(base_url)user/"
    static let url_user_upload_icon = "\(base_url)user/upload/"
    static let url_user_follows = "\(base_url)user/follows/"
    static let url_user_follow_status = "\(base_url)user/follow/status/"
    static let url_user_follow = "\(base_url)user/follow/"
    static let url_user_followers = "\(base_url)user/followers/"
    static let url_token_validate = "\(base_url)user/validate/"
    static let url_user_feedback = "\(base_url)user/feedback"
    static let url_user_set_black = "\(base_url)user/black/"
    static let url_user_list_blacks = "\(base_url)user/blacks/"
    static let url_user_operations = "\(base_url)user/operations/"
    
    static let url_wss_live = "wss://blive.bvision.live/live/"
    
    static let link_app_qrcode = "https://blive.bvision.live/qrcode/"
    
    static let jsonHeaders: HTTPHeaders = [
    "ContentType": "application/json"
    ]
    
    static let key_user_id = "userId"
    static let key_username = "username"
    static let key_token = "token"
    static let key_user_icon = "user_icon"
    static let key_user_level = "user_level"
    
    static let key_channel_play_url = "play_url"
    static let key_channel_push_url = "push_full_url"
    static let key_channel_title = "channel_title"
    static let key_channel_message = "channel_message"
    static let key_channel_link = "channel_link"
    static let key_channel_price = "channel_price"
    static let key_channel_rating = "channel_rating"
    static let key_channel_preview = "channel_preview"
    
    static let key_live_play_channel_token = "channel_play_token"
    
    static let regex_email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    
    static let youtube_api_key = "AIzaSyAIA8B1C5fBhuZ6duquFzeiWaSBlUoJveQ"
    
    static func makeURL(_ url: String) -> URL{
        let url = URL(string: url)
        return url!
    }
    
    static let ratingIcons = [#imageLiteral(resourceName: "g_icon"), #imageLiteral(resourceName: "pg_icon"), #imageLiteral(resourceName: "pg13_icon"), #imageLiteral(resourceName: "r_icon"), #imageLiteral(resourceName: "nc17_icon")]
}
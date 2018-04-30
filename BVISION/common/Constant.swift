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
    
    static let debug = true
    
    
    //MARK:- URL-BASE
    static let base_url = "https://blive.bvision.live/"
    
    static let url_channel = "\(base_url)channel/"
    static let url_channel_living = "\(base_url)channel/living"
    static let url_channel_search = "\(base_url)channel/search/"
    static let url_channel_update_all_info = "\(base_url)channel/update/0"
    static let url_channel_update_status = "\(base_url)channel/status/"
    static let url_channel_upload_preview = "\(base_url)channel/upload/"
    
    
    static let url_clips = "\(base_url)clips/"
    
    
    static let url_images_ad = "\(base_url)images/"
    
    
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
    static let url_user_gender = "\(base_url)user/gender/"
    static let url_user_profile = "\(base_url)user/profile/"
    
    
    static let url_coin_get = "\(base_url)coin/"
    static let url_coin_purchase_verify = "\(base_url)coin/iap/verify/"
    static let url_coin_consume = "\(base_url)coin/consume/"
    static let url_coin_bill = "\(base_url)coin/bill/"
    
    //MARK:- URL-PANEL
    static let panel_url = "http://panel.ldlegacy.com/panel/"
    
    static let url_trending = "\(panel_url)trending/"
    static let url_friends = "\(panel_url)friends/"
    static let url_groups = "\(panel_url)groups/"
    static let url_groups_icon = "\(panel_url)groups/icon/"
    
    
    //MARK:- URL-WS
    static let url_wss_live = "wss://blive.bvision.live/live/"
    
    
    //MARK:- LINK
    static let link_app_qrcode = "https://blive.bvision.live/qrcode/"
    static let link_help = "https://blive.bvision.live/Resource/html/ios_help.html"
    static let link_purchase_consent = "https://blive.bvision.live/Resource/html/purchase_consent.html"
    
    
    //MARK:- HEAD
    static let urlencodedHeaders: HTTPHeaders = [
    "ContentType": "application/x-www-form-urlencoded"
    ]
    static let jsonHeaders: HTTPHeaders = [
        "ContentType": "application/json"
    ]
    
    
    //MARK:- UF-KEY
    static let key_user_id = "userId"
    static let key_username = "username"
    static let key_token = "token"
    static let key_user_icon = "user_icon"
    static let key_user_level = "user_level"
    static let key_user_gender = "user_gender"
    static let key_user_profile = "user_profile"
    static let key_user_coins = "user_coins"
    
    static let key_channel_play_url = "play_url"
    static let key_channel_push_url = "push_full_url"
    static let key_channel_title = "channel_title"
    static let key_channel_message = "channel_message"
    static let key_channel_link = "channel_link"
    static let key_channel_price = "channel_price"
    static let key_channel_rating = "channel_rating"
    static let key_channel_preview = "channel_preview"
    
    static let key_live_play_channel_token = "channel_play_token"
    
    
    //MARK:- REGEX
    static let regex_email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    
    
    //MARK:- API-KEY
    static let youtube_api_key = "AIzaSyAIA8B1C5fBhuZ6duquFzeiWaSBlUoJveQ"
    
    
    //MARk:- RESULT-KEY
    static let code = "code"
    static let msg = "message"
    static let data = "data"
    static let data_list = "dataList"
    
    static let ratingIcons = [#imageLiteral(resourceName: "g_icon"), #imageLiteral(resourceName: "pg_icon"), #imageLiteral(resourceName: "pg13_icon"), #imageLiteral(resourceName: "r_icon"), #imageLiteral(resourceName: "nc17_icon")]
}

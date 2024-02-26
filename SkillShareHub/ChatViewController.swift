//
//  ChatViewController.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 25/02/2024.
//

import StreamChat
import StreamChatUI
import UIKit

class ChatViewController: ChatChannelListVC {

    struct ChatView: View {
    var body: some View {
        ChannelListView(streamChatClient: streamChatClient)
    }
}

}

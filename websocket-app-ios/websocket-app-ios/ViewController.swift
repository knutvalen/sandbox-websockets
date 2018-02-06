//
//  ViewController.swift
//  websocket-app-ios
//
//  Created by Knut Valen on 05/02/2018.
//  Copyright © 2018 Knut Valen. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    
    var socket: WebSocket!

    @IBOutlet weak var connectButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "http://localhost:8080")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request, protocols: ["echo-protocol"])
        socket.delegate = self
        socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: WebSocketDelegate methods
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket connected")
        connectButton.title = "Disconnect"
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket disconnected")
        connectButton.title = "Connect"
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("recieved text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("recieved data: \(data)")
    }
    
    // MARK: Actions
    
    @IBAction func handleConnection(_ sender: UIBarButtonItem) {
        if socket.isConnected {
            socket.disconnect()
        } else {
            socket.connect()
        }
    }
}


//
//  ViewController.swift
//  websocket-app-ios
//
//  Created by Knut Valen on 05/02/2018.
//  Copyright © 2018 Knut Valen. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate, WebSocketPongDelegate {
    
    var socket: WebSocket!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "http://localhost:8080")!)
        request.timeoutInterval = 5
        let protocols = ["echo"]
        socket = WebSocket(request: request, protocols: protocols)
        socket.delegate = self
        socket.pongDelegate = self
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
    
    // MARK: WebSocketPongDelegate methods
    
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        print("recieved pong")
    }
    
    // MARK: Actions
    
    @IBAction func handleConnection(_ sender: UIBarButtonItem) {
        if socket.isConnected {
            socket.disconnect()
        } else {
            socket.connect()
        }
    }
    
    @IBAction func binaryFrameButtonClicked(_ sender: UIButton) {
        socket.write(data: Data(bytes: [1, 2, 3, 4, 5, 6, 7, 8]))
    }
    
    @IBAction func stringFrameButtonClicked(_ sender: UIButton) {
        socket.write(string: "Hello World!")
    }
    
    @IBAction func pingFrameButtonClicked(_ sender: UIButton) {
        socket.write(ping: Data())
    }
}

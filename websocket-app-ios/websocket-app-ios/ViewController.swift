//
//  ViewController.swift
//  websocket-app-ios
//
//  Created by Knut Valen on 05/02/2018.
//  Copyright © 2018 Knut Valen. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebSocketDelegate, WebSocketPongDelegate {
    
    // MARK: - Properties

    var socket: WebSocket!
    var messages = [Message]()
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var messageTableView: UITableView!
    
    // MARK: - UIViewController functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = URLRequest(url: URL(string: "http://localhost:8080")!)
        request.timeoutInterval = 5
        let protocols = ["echo"]
        socket = WebSocket(request: request, protocols: protocols)
        socket.delegate = self
        socket.pongDelegate = self
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - WebSocketDelegate functions
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket connected")
        connectButton.title = "Disconnect"
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket disconnected")
        connectButton.title = "Connect"
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let description = "recieved text: \(text)"
        print(description)
        addMessageToTableView(description: description)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        let description = "recieved data: \(data)"
        print(description)
        addMessageToTableView(description: description)
    }
    
    // MARK: - WebSocketPongDelegate functions
    
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        let description = "recieved pong"
        print(description)
        addMessageToTableView(description: description)
    }
    
    // MARK: - Actions
    
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
    
    // MARK: - Private functions
    
    func addMessageToTableView(description: String) {
        guard let message = Message(description: description) else {
            fatalError("Unable to instantiate message")
        }
        
        messages.insert(message, at: 0)
        messageTableView.reloadData()
    }
    
    // MARK: - Table view functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
            fatalError("The dequeued cell is not an instance of MessageTableViewCell. ")
        }
        
        let message = messages[indexPath.row]
        cell.descriptionLabel.text = message.description
        
        return cell
    }
}

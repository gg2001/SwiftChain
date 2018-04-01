import UIKit
import PlaygroundSupport

public func random(_ range:Range<Int>) -> Int
{
    return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
}

var genesisKey = random(201..<999)
var genesisAddress = genesisKey * 5
var testKey = random(201..<999)
var testAddress = testKey * 5
var accounts: [String: Int] = ["0000": 21000000]
let reward = 50

public class Block {
    var hash = String()
    var data = String()
    var previousHash = String()
    var index = Int()
    func createHash() -> String {
        return NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
public class BlockChain {
    var chain = [Block]()
    func createGenesisBlock(data:String) {
        let genesisBlock = Block()
        genesisBlock.hash = genesisBlock.createHash()
        genesisBlock.data = data
        genesisBlock.previousHash = "genesisBlock"
        genesisBlock.index = 0
        chain.append(genesisBlock)
    }
    func addBlock(data:String) {
        let newBlock = Block()
        newBlock.hash = newBlock.createHash()
        newBlock.data = data
        newBlock.previousHash = chain[chain.count-1].hash
        newBlock.index = chain.count
        chain.append(newBlock)
    }
}
let swiftchain = BlockChain()
public func transaction(from: String, to: String, amount: Int, type: String) {
    if accounts[from] == nil {
        exit(0)
    } else if accounts[from]!-amount < 0 {
        exit(0)
    } else {
        accounts.updateValue(accounts[from]!-amount, forKey: from)
    }
    if accounts[to] == nil {
        accounts.updateValue(amount, forKey: to)
    } else {
        accounts.updateValue(accounts[to]!+amount, forKey: to)
    }
    if type == "genesis" {
        swiftchain.createGenesisBlock(data: "From: \(from); To: \(to); Amount: \(amount)XSC")
    } else if type == "normal" {
        swiftchain.addBlock(data: "From: \(from); To: \(to); Amount: \(amount)XSC")
    }
    if amount < 0 {
        exit(0)
    }
}
func chainValidity() -> String {
    var isChainValid = true
    for i in 1...swiftchain.chain.count-1 {
        if swiftchain.chain[i].previousHash != swiftchain.chain[i-1].hash {
            isChainValid = false
        }
    }
    return "Chain is valid: \(isChainValid)\n"
}
func chainState() {
    for i in 0...swiftchain.chain.count-1 {
        print("\tBlock: \(swiftchain.chain[i].index)\n\tHash: \(swiftchain.chain[i].hash)\n\tPreviousHash: \(swiftchain.chain[i].previousHash)\n\tData: \(swiftchain.chain[i].data)")
    }
    print(accounts)
    print(chainValidity())
}

class MyViewController : UIViewController {
    var account1 = UILabel()
    var balance1 = UILabel()
    var mine1 = UIButton(type: .system)
    var send1 = UITextField()
    var amount1 = UITextField()
    var transact1 = UIButton(type: .system)
    var backup1 = UILabel()
    var login1 = UITextField()
    var backuplogin1 = UIButton(type: .system)
    
    public override func loadView() {
        transaction(from: "0000", to: "\(genesisAddress)", amount: 50, type: "genesis")
        transaction(from: "\(genesisAddress)", to: "\(testAddress)", amount: 10, type: "normal")
        transaction(from: "\(testAddress)", to: "\(genesisAddress)", amount: 10, type: "normal")
        chainState()
        
        let view = UIView()
        view.backgroundColor = .white
        
        //account1.frame = CGRect(x: 10, y: 200, width: 200, height: 20)
        account1.text = "Account: \(genesisAddress)"
        account1.textColor = .black
        account1.translatesAutoresizingMaskIntoConstraints = false
        balance1.text = "Balance: \(accounts[String(describing: genesisAddress)]!)XSC"
        balance1.textColor = .black
        balance1.translatesAutoresizingMaskIntoConstraints = false
        mine1.setTitle("Mine", for: .normal)
        mine1.addTarget(self, action: #selector(mineFunc1), for: .touchUpInside)
        mine1.translatesAutoresizingMaskIntoConstraints = false
        send1.borderStyle = .roundedRect
        send1.placeholder = "Send to account number"
        send1.keyboardType = UIKeyboardType.numberPad
        send1.translatesAutoresizingMaskIntoConstraints = false
        amount1.borderStyle = .roundedRect
        amount1.placeholder = "Amount of coins to send "
        amount1.keyboardType = UIKeyboardType.numberPad
        amount1.translatesAutoresizingMaskIntoConstraints = false
        transact1.setTitle("Send", for: .normal)
        transact1.addTarget(self, action: #selector(sendFunc1), for: .touchUpInside)
        transact1.translatesAutoresizingMaskIntoConstraints = false
        backup1.text = "Backup code: \(genesisKey)"
        backup1.textColor = .black
        backup1.translatesAutoresizingMaskIntoConstraints = false
        login1.borderStyle = .roundedRect
        login1.placeholder = "Login to account with backup code"
        login1.keyboardType = UIKeyboardType.numberPad
        login1.translatesAutoresizingMaskIntoConstraints = false
        backuplogin1.setTitle("Login", for: .normal)
        backuplogin1.addTarget(self, action: #selector(loginFunc1), for: .touchUpInside)
        backuplogin1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(account1)
        view.addSubview(balance1)
        view.addSubview(mine1)
        view.addSubview(send1)
        view.addSubview(amount1)
        view.addSubview(transact1)
        view.addSubview(backup1)
        view.addSubview(login1)
        view.addSubview(backuplogin1)
        //let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            account1.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            account1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balance1.leadingAnchor.constraint(equalTo: account1.trailingAnchor, constant: 20),
            balance1.firstBaselineAnchor.constraint(equalTo: account1.firstBaselineAnchor),
            mine1.leadingAnchor.constraint(equalTo: balance1.trailingAnchor, constant: 20),
            mine1.firstBaselineAnchor.constraint(equalTo: balance1.firstBaselineAnchor),
            send1.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            send1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amount1.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            amount1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transact1.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            transact1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backup1.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            backup1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            login1.topAnchor.constraint(equalTo: view.topAnchor, constant: 260),
            login1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backuplogin1.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            backuplogin1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
        
        self.view = view
    }
    @objc func mineFunc1() {
        transaction(from: "0000", to: "\(genesisAddress)", amount: 50, type: "normal")
        balance1.text = "Balance: \(accounts[String(describing: genesisAddress)]!)XSC"
        print("New block mined by: \(genesisAddress)")
        chainState()
    }
    @objc func sendFunc1() {
        transaction(from: "\(genesisAddress)", to: "\(send1.text!)", amount: Int(amount1.text!)!, type: "normal")
        balance1.text = "Balance: \(accounts[String(describing: genesisAddress)]!)XSC"
        print("\(amount1.text!)XSC sent from \(genesisAddress) to \(send1.text!)")
        chainState()
        send1.text = ""
        amount1.text = ""
    }
    @objc func loginFunc1() {
        genesisKey = Int(login1.text!)!
        genesisAddress = genesisKey * 5
        if accounts[String(describing: genesisAddress)] == nil {
            account1.text = "Account: \(genesisAddress)"
            balance1.text = "Balance: 0XSC"
            backup1.text = "Backup code: \(genesisKey)"
        } else {
            account1.text = "Account: \(genesisAddress)"
            balance1.text = "Balance: \(accounts[String(describing: genesisAddress)]!)XSC"
            backup1.text = "Backup code: \(genesisKey)"
        }
        print("Logged into account \(genesisAddress) with wallet 1\n")
        login1.text = ""
    }
}
let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 768, height: 1024)
PlaygroundPage.current.liveView = viewController

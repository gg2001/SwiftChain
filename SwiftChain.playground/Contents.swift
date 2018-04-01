// WWDC2018 Scholarship Submission by Gautham Elango
// SwiftChain is a simple cryptocurrency in a Swift playground written in under 400 lines.
// It uses a Blockchain to record transactions, public keys (account numbers) and private keys (backup codes) to secure funds, and proof of work mining to produce new coins. The "blocksize" is one transaction per block. It is similar to a typical cryptocurrency except that it doesn't allow transactions over internet, lacks security, and isn't as robust.
// This can act as a demonstration of how a Blockchain functions.
// XSC is the currency ticker and there is a maximum supply of 21000000XSC, similar to Bitcoin. The mining reward is 50XSC.
// The Blockchain is only stored in a dictionary so once this playground is stopped the data will be erased, and a new Blockchain will be created when you start it up again.
// Open the Assistant Editor to interact with the Blockchain. There are two wallets running side by side which allows you to see transactions happening in real time. Make sure it is opened wide since the size of the view is quite large (768x1024).
// If you open the debug area you can explore the Blockchain, and see who owns what. 0000 is the network address from which mined coins are sent. The Blockchain cannot be tampered with since every transaction is hashed.
// In the Assitant editor you can send, receive and mine coins. You can also create new accounts and login back to an account you used previously by entering the backup code associated with that account. Account numbers are typically 4 digits and backup codes are typically 3 digits.
// This playground was tested and developed on Xcode 9.2.
// Important note: This cryptocurrency doesn't support decimals so attempting to send fractions of a coin will crash the playground. Also attempting to spend non-existent coins will crash the playground. This demostrates the integrity of Blockchains.

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
        print("Invalid transaction\n")
        exit(0)
    } else if accounts[from]!-amount < 0 {
        print("Invalid transaction\n")
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
        print("Invalid transaction\n")
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
    var new1 = UIButton(type: .system)
    var account2 = UILabel()
    var balance2 = UILabel()
    var mine2 = UIButton(type: .system)
    var send2 = UITextField()
    var amount2 = UITextField()
    var transact2 = UIButton(type: .system)
    var backup2 = UILabel()
    var login2 = UITextField()
    var backuplogin2 = UIButton(type: .system)
    var new2 = UIButton(type: .system)
    var wallet1 = UILabel()
    var wallet2 = UILabel()
    
    public override func loadView() {
        transaction(from: "0000", to: "\(genesisAddress)", amount: 50, type: "genesis")
        transaction(from: "\(genesisAddress)", to: "\(testAddress)", amount: 10, type: "normal")
        transaction(from: "\(testAddress)", to: "\(genesisAddress)", amount: 10, type: "normal")
        chainState()
        
        let view = UIView()
        view.backgroundColor = .white
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
        new1.setTitle("Logout and create new account", for: .normal)
        new1.addTarget(self, action: #selector(newFunc1), for: .touchUpInside)
        new1.translatesAutoresizingMaskIntoConstraints = false
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
        account2.text = "Account: \(testAddress)"
        account2.textColor = .black
        account2.translatesAutoresizingMaskIntoConstraints = false
        balance2.text = "Balance: \(accounts[String(describing: testAddress)]!)XSC"
        balance2.textColor = .black
        balance2.translatesAutoresizingMaskIntoConstraints = false
        mine2.setTitle("Mine", for: .normal)
        mine2.addTarget(self, action: #selector(mineFunc2), for: .touchUpInside)
        mine2.translatesAutoresizingMaskIntoConstraints = false
        send2.borderStyle = .roundedRect
        send2.placeholder = "Send to account number"
        send2.keyboardType = UIKeyboardType.numberPad
        send2.translatesAutoresizingMaskIntoConstraints = false
        amount2.borderStyle = .roundedRect
        amount2.placeholder = "Amount of coins to send "
        amount2.keyboardType = UIKeyboardType.numberPad
        amount2.translatesAutoresizingMaskIntoConstraints = false
        transact2.setTitle("Send", for: .normal)
        transact2.addTarget(self, action: #selector(sendFunc2), for: .touchUpInside)
        transact2.translatesAutoresizingMaskIntoConstraints = false
        new2.setTitle("Logout and create new account", for: .normal)
        new2.addTarget(self, action: #selector(newFunc2), for: .touchUpInside)
        new2.translatesAutoresizingMaskIntoConstraints = false
        backup2.text = "Backup code: \(testKey)"
        backup2.textColor = .black
        backup2.translatesAutoresizingMaskIntoConstraints = false
        login2.borderStyle = .roundedRect
        login2.placeholder = "Login to account with backup code"
        login2.keyboardType = UIKeyboardType.numberPad
        login2.translatesAutoresizingMaskIntoConstraints = false
        backuplogin2.setTitle("Login", for: .normal)
        backuplogin2.addTarget(self, action: #selector(loginFunc2), for: .touchUpInside)
        backuplogin2.translatesAutoresizingMaskIntoConstraints = false
        wallet1.text = "Wallet 1"
        wallet1.textColor = .black
        wallet1.font = wallet1.font.withSize(40)
        wallet1.translatesAutoresizingMaskIntoConstraints = false
        wallet2.text = "Wallet 2"
        wallet2.textColor = .black
        wallet2.font = wallet2.font.withSize(40)
        wallet2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(account1)
        view.addSubview(balance1)
        view.addSubview(mine1)
        view.addSubview(send1)
        view.addSubview(amount1)
        view.addSubview(transact1)
        view.addSubview(new1)
        view.addSubview(backup1)
        view.addSubview(login1)
        view.addSubview(backuplogin1)
        view.addSubview(account2)
        view.addSubview(balance2)
        view.addSubview(mine2)
        view.addSubview(send2)
        view.addSubview(amount2)
        view.addSubview(transact2)
        view.addSubview(new2)
        view.addSubview(backup2)
        view.addSubview(login2)
        view.addSubview(backuplogin2)
        view.addSubview(wallet1)
        view.addSubview(wallet2)
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
            new1.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            new1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backup1.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            backup1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            login1.topAnchor.constraint(equalTo: view.topAnchor, constant: 340),
            login1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backuplogin1.topAnchor.constraint(equalTo: view.topAnchor, constant: 380),
            backuplogin1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            account2.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            account2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            balance2.leadingAnchor.constraint(equalTo: account2.trailingAnchor, constant: 20),
            balance2.firstBaselineAnchor.constraint(equalTo: account2.firstBaselineAnchor),
            mine2.leadingAnchor.constraint(equalTo: balance2.trailingAnchor, constant: 20),
            mine2.firstBaselineAnchor.constraint(equalTo: balance2.firstBaselineAnchor),
            send2.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            send2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            amount2.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            amount2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            transact2.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            transact2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            new2.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            new2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            backup2.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            backup2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            login2.topAnchor.constraint(equalTo: view.topAnchor, constant: 340),
            login2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            backuplogin2.topAnchor.constraint(equalTo: view.topAnchor, constant: 380),
            backuplogin2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 404),
            wallet1.topAnchor.constraint(equalTo: view.topAnchor, constant: 440),
            wallet1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 102),
            wallet2.topAnchor.constraint(equalTo: view.topAnchor, constant: 440),
            wallet2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 486)
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
        if send1.text == "" || amount1.text == "" {
            print("Please enter a value\n")
        } else {
            transaction(from: "\(genesisAddress)", to: "\(send1.text!)", amount: Int(amount1.text!)!, type: "normal")
            if accounts[String(describing: genesisAddress)] == nil {
                balance1.text = "Balance: 0XSC"
            } else {
                balance1.text = "Balance: \(accounts[String(describing: genesisAddress)]!)XSC"
            }
            if accounts[String(describing: testAddress)] == nil {
                balance2.text = "Balance: 0XSC"
            } else {
                balance2.text = "Balance: \(accounts[String(describing: testAddress)]!)XSC"
            }
            print("\(amount1.text!)XSC sent from \(genesisAddress) to \(send1.text!)")
            chainState()
            send1.text = ""
            amount1.text = ""
        }
    }
    @objc func newFunc1() {
        genesisKey = random(201..<999)
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
    }
    @objc func loginFunc1() {
        if login1.text == "" {
            print("Please enter a value\n")
        } else {
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
    @objc func mineFunc2() {
        transaction(from: "0000", to: "\(testAddress)", amount: 50, type: "normal")
        balance2.text = "Balance: \(accounts[String(describing: testAddress)]!)XSC"
        print("New block mined by: \(testAddress)")
        chainState()
    }
    @objc func sendFunc2() {
        if send2.text == "" || amount2.text == "" {
            print("Please enter a value\n")
        } else {
            transaction(from: "\(testAddress)", to: "\(send2.text!)", amount: Int(amount2.text!)!, type: "normal")
            if accounts[String(describing: genesisAddress)] == nil {
                balance1.text = "Balance: 0XSC"
            } else {
                balance1.text = "Balance: \(accounts[String(describing: genesisAddress)]!)XSC"
            }
            if accounts[String(describing: testAddress)] == nil {
                balance2.text = "Balance: 0XSC"
            } else {
                balance2.text = "Balance: \(accounts[String(describing: testAddress)]!)XSC"
            }
            print("\(amount2.text!)XSC sent from \(testAddress) to \(send2.text!)")
            chainState()
            send2.text = ""
            amount2.text = ""
        }
    }
    @objc func newFunc2() {
        testKey = random(201..<999)
        testAddress = testKey * 5
        if accounts[String(describing: testAddress)] == nil {
            account2.text = "Account: \(testAddress)"
            balance2.text = "Balance: 0XSC"
            backup2.text = "Backup code: \(testKey)"
        } else {
            account2.text = "Account: \(testAddress)"
            balance2.text = "Balance: \(accounts[String(describing: testAddress)]!)XSC"
            backup2.text = "Backup code: \(testKey)"
        }
        print("Logged into account \(testAddress) with wallet 2\n")
    }
    @objc func loginFunc2() {
        if login2.text == "" {
            print("Please enter a value\n")
        } else {
            testKey = Int(login2.text!)!
            testAddress = testKey * 5
            if accounts[String(describing: testAddress)] == nil {
                account2.text = "Account: \(testAddress)"
                balance2.text = "Balance: 0XSC"
                backup2.text = "Backup code: \(testKey)"
            } else {
                account2.text = "Account: \(testAddress)"
                balance2.text = "Balance: \(accounts[String(describing: testAddress)]!)XSC"
                backup2.text = "Backup code: \(testKey)"
            }
            print("Logged into account \(testAddress) with wallet 2\n")
            login2.text = ""
        }
    }
}

let vc = MyViewController()
vc.preferredContentSize = CGSize(width: 768, height: 1024)
PlaygroundPage.current.liveView = vc

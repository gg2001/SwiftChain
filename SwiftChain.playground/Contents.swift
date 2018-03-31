import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    public func random(_ range:Range<Int>) -> Int
    {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    var account1 = UILabel()
    var balance1 = UILabel()
    var account2 = UILabel()
    
    override func loadView() {
        let genesisKey = random(100..<999)
        let genesisAddress = genesisKey * 5
        var testKey = random(100..<999)
        let testAddress = testKey * 5
        var accounts: [String: Int] = ["0000": 21000000]
        let reward = 50
        
        class Block {
            var hash = String()
            var data = String()
            var previousHash = String()
            var index = Int()
            func createHash() -> String {
                return NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
            }
        }
        
        class BlockChain {
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
        func transaction(from: String, to: String, amount: Int, type: String) {
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
        transaction(from: "0000", to: "\(genesisAddress)", amount: 50, type: "genesis")
        transaction(from: "\(genesisAddress)", to: "\(testAddress)", amount: 10, type: "normal")
        
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
        chainState()
        
        let view = UIView()
        view.backgroundColor = .white
        
        //label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        account1.text = "Account: \(genesisAddress)"
        account1.textColor = .black
        account1.translatesAutoresizingMaskIntoConstraints = false
        balance1.text = "Balance: "
        balance1.textColor = .black
        balance1.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        /*
        NSLayoutConstraint.activate([
            account1.leadingAnchor.constraint(equalTo: balance1.leadingAnchor),
            account1.topAnchor.constraint(equalTo: balance1.bottomAnchor, constant: 10),
            ])
        */
        
        view.addSubview(account1)
        view.addSubview(balance1)
        self.view = view
        
        transaction(from: "\(testAddress)", to: "5789", amount: 10, type: "normal")
        chainState()
        transaction(from: "5789", to: "\(testAddress)", amount: 10, type: "normal")
        chainState()
    }
}

PlaygroundPage.current.liveView = MyViewController()

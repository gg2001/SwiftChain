import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    let label = UILabel()
    
    override func loadView() {
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
        swiftchain.createGenesisBlock(data: "From: Gautham; To: Apple; Amount: 10XSC")
        swiftchain.addBlock(data: "From: Apple; To: Gautham; Amount: 8XSC")
        swiftchain.addBlock(data: "From: Gautham; To: Apple; Amount: 2XSC")
        // swiftchain.chain[1].data <- prints data
        // swiftchain.chain[1].hash = "invalid" <- renders chain invalid
        
        for i in 0...swiftchain.chain.count-1 {
            print("\tBlock: \(swiftchain.chain[i].index)\n\tHash: \(swiftchain.chain[i].hash)\n\tPreviousHash: \(swiftchain.chain[i].previousHash)\n\tData: \(swiftchain.chain[i].data)\n")
        }
        
        var isChainValid = true
        for i in 1...swiftchain.chain.count-1 {
            if swiftchain.chain[i].previousHash != swiftchain.chain[i-1].hash {
                isChainValid = false
            }
        }
        print("Chain is valid: \(isChainValid)")
        
        let view = UIView()
        view.backgroundColor = .white
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "SwiftChain"
        label.textColor = .black
        view.addSubview(label)
        self.view = view
    }
}

PlaygroundPage.current.liveView = MyViewController()

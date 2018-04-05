# SwiftChain

[![Xcode](https://img.shields.io/badge/Xcode-9.2-brightgreen.svg)](https://developer.apple.com/news/releases/) [![Swift](https://img.shields.io/badge/Swift-4.0-brightgreen.svg)](https://swift.org/blog/swift-4-0-released/)


Simple Cryptocurrency in a Swift Playground

https://youtu.be/4i_TtI5YmCs

It uses a Blockchain to record transactions, public keys (account numbers) and private keys (backup codes) to secure funds, and proof of work mining to produce new coins. The "blocksize" is one transaction per block. It is similar to a typical cryptocurrency except that it doesn't allow transactions over internet, lacks security, and isn't as robust.
This can act as a demonstration of how a Blockchain functions.
XSC is the currency ticker and there is a maximum supply of 21000000XSC, similar to Bitcoin. The mining reward is 50XSC.
The Blockchain is only stored in a dictionary so once this playground is stopped the data will be erased, and a new Blockchain will be created when you start it up again.
Open the Assistant Editor to interact with the Blockchain. There are two wallets running side by side which allows you to see transactions happening in real time. Make sure it is opened wide since the size of the view is quite large (768x1024).
If you open the debug area you can explore the Blockchain, and see who owns what. 0000 is the network address from which mined coins are sent. The Blockchain cannot be tampered with since every transaction is hashed.
In the Assitant editor you can send, receive and mine coins. You can also create new accounts and login back to an account you used previously by entering the backup code associated with that account. Account numbers are typically 4 digits and backup codes are typically 3 digits.

This playground was tested and developed on Xcode 9.2.
Important note: This cryptocurrency doesn't support decimals so attempting to send fractions of a coin will crash the playground. Also attempting to spend non-existent coins will crash the playground. This demostrates the integrity of Blo

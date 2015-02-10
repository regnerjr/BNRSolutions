import UIKit


enum ChannelParameters {
    case Title
    case Description
}

class RSSChannel: NSObject {
    var parentDelegate: NSXMLParserDelegate?
    var title: String?
    var infoString: String?
    var currentlyUpdating: ChannelParameters?
    var items = [RSSItem]()
   
}

extension RSSChannel : NSXMLParserDelegate {

    func parser(parser: NSXMLParser!, didStartElement elementName: String!,
            namespaceURI: String!, qualifiedName qName: String!,
            attributes attributeDict: [NSObject : AnyObject]!) {

        println("\t\(self) found a \(elementName) element")

        if elementName == "title"{
            currentlyUpdating = .Title
        } else if elementName == "description" {
            currentlyUpdating = .Description
        } else if elementName == "item" {
            currentlyUpdating = nil
            var entry = RSSItem()
            entry.parentParserDelegate = self
            parser.delegate = entry
            items.append(entry)
            println("Adding Entry for : \(entry.title)")
        } else {
            currentlyUpdating = nil
        }
    }

    func parser(parser: NSXMLParser!, foundCharacters string: String!) {

        if let string = string {
            switch currentlyUpdating {
            case .Some(.Title):
                title = string
                currentlyUpdating = nil
            case .Some(.Description):
                infoString = string
                currentlyUpdating = nil
            case .None:
                break //do nothing if updating is not set
            }
        }
    }

    func parser(parser: NSXMLParser!, didEndElement elementName: String!,
            namespaceURI: String!, qualifiedName qName: String!) {

        if elementName == "channel"{
            parser.delegate = parentDelegate
        }
    }
}

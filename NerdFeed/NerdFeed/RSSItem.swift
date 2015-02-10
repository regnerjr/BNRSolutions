import UIKit

enum ItemParameters {
    case Title
    case Link
}

class RSSItem: NSObject {
    var parentParserDelegate: NSXMLParserDelegate?
    var title: String?
    var link: String?
    var currentlyUpdating: ItemParameters?

}

extension RSSItem: NSXMLParserDelegate {

    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        println("\t\t\(self) found a \(elementName) element")
        if elementName == "title" {
            currentlyUpdating = .Title
        } else if elementName == "link" {
            currentlyUpdating = .Link
        } else {
            currentlyUpdating = nil
        }
    }

    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if let string = string {
            switch currentlyUpdating {
            case .Some(.Title):
                title = append(title, string)
            case .Some(.Link):
                link = append(link, string)
            case .None:
                break //nothing to do here
            }
        }
    }
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == "item" {
            parser.delegate = parentParserDelegate
        }
    }
}


func append(maybeNil: Optional<String>, maybeAppend: Optional<String>) -> String{
    let first = maybeNil ?? ""
    let second = maybeAppend ?? ""
    return first + second
}
import UIKit

class ListViewController: UITableViewController {
    
    var connection: NSURLConnection?
    var xmlData: NSMutableData?
    var channel: RSSChannel?

    //MARK: - Init
    override init(style: UITableViewStyle) {
        super.init(style: style)
        fetchEntries()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = channel?.items.count ?? 0
        println("item count: \(itemCount)")
        return itemCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        let item = channel?.items[indexPath.row]
        cell.textLabel?.text = item?.title

        return cell
    }
    
    func fetchEntries(){
        //new data container for the data returned
        xmlData = NSMutableData()

        //construct URL
        if let url = NSURL(string: "http://forums.bignerdranch.com/smartfeed.php?"
            + "limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"){
            //make a request
            let req = NSURLRequest(URL: url)
            //start a connection
            connection = NSURLConnection(request: req, delegate: self, startImmediately: true)

        }
    }

    func connection(conn: NSURLConnection, didReceiveData data: NSData){
        xmlData?.appendData(data)
    }
}


extension ListViewController: NSURLConnectionDataDelegate {

    func connectionDidFinishLoading(connection: NSURLConnection) {
        //make sure we got some data
        if let data = xmlData {
            let xmlCheck = NSString(data: data, encoding: NSUTF8StringEncoding)

            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
            self.xmlData = nil
            self.connection = nil
            tableView.reloadData()
            println(" - \(channel)")
            println(" - \(channel?.title)")
            println(" - \(channel?.infoString)")
        }
    }

    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        //release the connection we are done with it
        self.connection = nil
        self.xmlData = nil
        let errorString = String(format: "FetchFailed: %@", arguments: [error.localizedDescription])


        let av = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "OK")
        av.show()
    }

}

extension ListViewController: NSXMLParserDelegate {
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        println("\(self) found a \(elementName) element")
        if elementName == "channel" {
            channel = RSSChannel()
            channel?.parentDelegate = self
            parser.delegate = channel as? NSXMLParserDelegate
        }
    }
}
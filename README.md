# Money #

The Money app can help to take care of your daily expenses and create some awesome graphics of statistics.

Hope the prototype will come out soon. 

I build this just to learn `Node.js`.

## Models ##
This project uses NoSQL to store data. Hopefully the model prototype below should serve well.

    {
         "user": "lambda"
        ,"content": "shopping at Walmart"
        ,"date": "6/11/2012"
        ,"tags": ["shopping", "walmart", "weekly"]
        ,"amount": 23.6
        ,"payment": "credit card"
        ,"note": "paid by Amy"
    }

## Views ##

### index ###

Entrances to others.

### input ###

* **Manual Input**
A user could manually input expense items by giving its content, amount and optionally its date if it's a past item, payment if it's different than the default one, note if any, tags if any for future statistics uses.

* **Auto Load**
One could also input by supplying a file (Excel or comma separated or JSON or XML or just plain text files). This calls for a very good and tolerant text parser.

### display ###

* **By Day**
* **By Month**
* **By Year**

Could be plain amount or graph.

### review ###

* By Tag (Tag clouds)
* Bar Graph (Grouped by Tag or Class)
* Curve Graph (Grouped by Tag or Class)
* Tips and Comments

### dump ###

Dump data to plain text, SQL or Excel.

### sync ###

Syncing with (hopefully) other SNS sites?

## Dependencies ##

* `express.js` - app framework based on node.js
* `Couchdb` - NoSQL database
* `jade` - for templated view-rendering
* `coffee-script` - just JavsScript
* `stylus` - better CSS

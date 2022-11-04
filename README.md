# Overview
This module provides an API to extract information from `json` values.

## Usage
This module has a single API: `read`. It takes a `json` value as the first argument and a `string` query (json path expression) as the second argument. The API extracts details from the provided `json` value requested by the provided query and returns the extracted details as `json`. The API returns an `Error` when an invalid string value is provided as the query.

The following examples show the usage of the module.

#### Example 1: Sample query experession 
```ballerina
import ballerina/io;
import xlibb/jsonpath as jp;

json store = {
    store: {
        book: [
            {
                category: "reference",
                author: "Nigel Rees",
                title: "Sayings of the Century",
                price: 8.95
            },
            {
                category: "fiction",
                author: "Evelyn Waugh",
                title: "Sword of Honour",
                price: 12.99
            },
            {
                category: "fiction",
                author: "Herman Melville",
                title: "Moby Dick",
                isbn: "0-553-21311-3",
                price: 8.99
            },
            {
                category: "fiction",
                author: "J. R. R. Tolkien",
                title: "The Lord of the Rings",
                isbn: "0-395-19395-8",
                price: 22.99
            }
        ],
        bicycle: {
            color: "red",
            price: 19.95
        }
    },
    expensive: 10
};

public function main() returns error? {
    json result = check jp:read(store, "$.store.book[*].author");
    io:println("The authors of all books: ", result); // ["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]

    result = check jp:read(store, "$.store..price");
    io:println("The price of everything: ", result); // [8.95,12.99,8.99,22.99,19.95]

    result = check jp:read(store, "$..book[1:2]");
    io:println("All books from index 1 (inclusive) until index 2 (exclusive): ", result);
    // [{"category":"fiction","author":"Evelyn Waugh","title":"Sword of Honour","price":12.99}]

    result = check jp:read(store, "$.store.book[?(@.price < 10)]['title', 'price']");
    io:println("All books title and price in store cheaper than 10: ", result);
    // [{"title":"Sayings of the Century","price":8.95},{"title":"Moby Dick","price":8.99}]
    
    result = check jp:read(store, "$..book[?(@.price <= $['expensive'])].title");
    io:println("All books titles in store that are not 'expensive': ", result); // ["Sayings of the Century","Moby Dick"]

    result = check jp:read(store, "$..book[?(@.author =~ /.*REES/i)].title");
    io:println("All books titles matching regex (ignore case): ", result); // ["Sayings of the Century"]

    result = check jp:read(store, "$..book.length()");
    io:println("The number of books: ", result); // 4

    result = check jp:read(store, "$.max($.store.book..price)");
    io:println("The maximum price of all books in the store: ", result); // 22.99

    result = check jp:read(store, "$..price.avg()");
    io:println("The average price of all items in the store: : ", result); // 14.7740
}
```

#### Example 2: Data binding after trasforming json
```ballerina
import ballerina/io;
import xlibb/jsonpath as jp;

json store = ...; //same as above, omitted for brevity

type Book record {
    string category;
    string author;
    string title;
    string isbn?;
    decimal price?;
};

public function main() returns error? {
    json result = check jp:read(store, "$..book[0:2]");

    Book[] books = check result.cloneWithType(); // data binding - this is natively supported by ballerina language
    io:println("Second Book price :", books[1].price); // 12.99
}
```



> **_NOTE:_** 
This module uses the java implementation of [JsonPath](https://github.com/json-path/JsonPath). To know more about supported operators/functions in the json path expression see [JsonPath README.md](https://github.com/json-path/JsonPath/blob/master/README.md)
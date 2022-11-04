import ballerina/io;
import ballerina/test;

@test:Config {}
isolated function runTestSuite() returns error? {
    json suite = check io:fileReadJson("tests/testsuite.json");
    json store = check suite.payload;
    json value = check suite.queries;
    string[] queries = check value.cloneWithType();
    value = check suite.results;
    json[] expectedResults = check value.cloneWithType();

    foreach int i in 0 ..< queries.length() {
        json result = check read(store, queries[i]);
        test:assertEquals(result, expectedResults[i]);
    }
}

@test:Config {}
isolated function testInvalidQuery() returns error? {
    json value = "data";
    string query = "$.search";
    json|Error result = read(value, query);
    test:assertTrue(result is Error);

    Error err = <Error>result;
    string expectedMessage = string `Unable to execute query '${query}' on the provided JSON value`;
    test:assertEquals(err.message(), expectedMessage);
}

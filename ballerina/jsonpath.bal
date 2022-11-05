import ballerina/jballerina.java;

# Extract details from the given json value using provided query expression
# + 'json - JSON value
# + query - JSON path expression
# + return - extracted details as JSON value, a jsonpath:Error otherwise
public isolated function read(json 'json, string query) returns json|Error = @java:Method {
    'class: "io.ballerina.xlibb.jsonpath.BJsonPath"
} external;

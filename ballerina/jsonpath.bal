import ballerina/jballerina.java;

public isolated function read(json 'json, string query) returns json|Error = @java:Method {
    'class: "io.ballerina.xlibb.jsonpath.BJsonPath"
} external;

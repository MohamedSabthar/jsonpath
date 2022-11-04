package io.ballerina.xlibb.jsonpath;

import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.JsonPathException;
import com.jayway.jsonpath.PathNotFoundException;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BString;
import net.minidev.json.JSONValue;

/**
 * Provides native function implementation of json-path.
 */
public class BJsonPath {
    public static Object read(Object json, BString query) {
        try {
            Object result = JsonPath.parse(json.toString()).read(query.getValue());
            return JsonUtils.parse(JSONValue.toJSONString(result));
        } catch (PathNotFoundException e) {
            BError cause = Utils.createError(e.getMessage());
            return Utils.createError(Utils.getCanNotExecuteQueryErrorMessage(query), cause);
        } catch (IllegalArgumentException | JsonPathException e) {
            return Utils.createError(e.getMessage());
        }
    }
}

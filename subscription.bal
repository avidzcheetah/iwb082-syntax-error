import ballerina/io;
import ballerina/http;

service /subscription on new http:Listener(8080) {
    private map<string> subscribers = {};

    resource function post subscribe(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        string email = check payload.email.toString();

        subscribers[email] = "subscribed";
        check caller->respond({"message": "Subscription successful!"});
        io:println("User subscribed with email: ", email);
    }

    resource function get subscribersList(http:Caller caller) returns error? {
        json result = subscribers;
        check caller->respond(result);
    }
}

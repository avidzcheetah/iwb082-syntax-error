import ballerina/email;
import ballerina/io;
import ballerina/task;

map<string> subscribers = {};

public function initSubscribers(map<string> currentSubscribers) {
    subscribers = currentSubscribers;
}

function notifyUsers(json weatherData) returns error? {
    string weatherCondition = weatherData.weather[0].description.toString();
    io:println("Weather condition: ", weatherCondition);

    if weatherCondition == "rain" {
        foreach var email in subscribers.keys() {
            sendWeatherAlert(email, weatherCondition);
        }
    }
}

function sendWeatherAlert(string email, string condition) returns error? {
    email:SmtpConfig smtpConfig = {
        host: "smtp.gmail.com",
        port: 587,
        username: "aviduw@gmail.com",
        password: "SallWe2313"
    };

    email:Message emailMessage = {
        subject: "Weather Alert!",
        to: email,
        body: "Attention! The weather condition is " + condition
    };

    email:SmtpClient emailClient = check new (smtpConfig);
    check emailClient->sendMessage(emailMessage);

    io:println("Weather alert sent to ", email);
}

listener task:Timer weatherCheckTimer = new(300000, 300000); 

service /weatherNotifier on weatherCheckTimer {
    resource function onTrigger() returns error? {
        json weatherData = check getWeatherData();
        check notifyUsers(weatherData);
    }
}

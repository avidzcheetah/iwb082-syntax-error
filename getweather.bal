import ballerina/http;

public function getWeatherData() returns json|error {
    http:Client weatherClient = check new("https://api.openweathermap.org");

    string path = "/data/2.5/weather?q=London&appid=fc4595252c6eddaba737fbd6af7daa1f";
    http:Response weatherResponse = check weatherClient->get(path);

    json weatherData = check weatherResponse.getJsonPayload();
    return weatherData;
}

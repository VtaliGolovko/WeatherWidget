public with sharing class DaysWithForecast {
    @AuraEnabled
    public String dateWeather {get; set;}
    @AuraEnabled
    public String temp {get; set;}
    @AuraEnabled
    public String condition {get; set;}
    @AuraEnabled
    public Boolean isItRain {get; set;}
    @AuraEnabled
    public Boolean isItSun {get; set;}
    @AuraEnabled
    public Boolean isItCloudy {get; set;}
    @AuraEnabled
    public Boolean isItParticalyCloudy {get; set;}

    public DaysWithForecast(){
        isItRain = false;
        isItSun = false;
        isItCloudy = false;
        isItParticalyCloudy = false;
    }
}

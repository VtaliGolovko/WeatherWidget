public with sharing class Weather {

    @AuraEnabled(cacheable =true)
    public static List<DaysWithForecast> getDaysWithForecast(String FarenOrCels, String location){
        List<Object> daysForecast = getForecastFor15Days(location);
        List<DaysWithForecast> daysWithForecast = new List<DaysWithForecast>();
        for(Object oneDayForecast: daysForecast) {
            daysWithForecast.add(setDayForecastFromObject(oneDayForecast, FarenOrCels));
        }   
        return daysWithForecast;
    }

    private static DaysWithForecast setDayForecastFromObject(Object oneDayForecast, String FarenOrCels){
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(oneDayForecast));
        DaysWithForecast day = setDayCondition(m.get('icon'));
        day.dateWeather = setDayOfWeekFromStringDate(m.get('datetime'));
        if(FarenOrCels == 'C'){
            day.temp = setTemperatureInCelsium(m.get('tempmax'));
        }else{
            day.temp = setTemperatureInFarengate(m.get('tempmax'));
        }
        
        return day;
    }

    //From 12-05-2022 to 05/12/2022
    private static String setDayOfWeekFromStringDate(Object objectDate){
        String stringDate = String.valueOf(objectDate);
        List<String> splitedDate = stringDate.split('-');
        String replacedDate = splitedDate[1]+'/'+splitedDate[2]+'/'+splitedDate[0];
        Date rightDate = date.parse(replacedDate);
        Datetime rightDateTime = (DateTime)rightDate;
        String dayOfWeek = rightDateTime.format('EEE');
        return dayOfWeek;
    }
    private static List<Object> getForecastFor15Days(String location){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/' + location + '?key='+ String.valueof(API_KEY_WEATHER__c.getOrgDefaults().key__c);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> daysForecast = (List<Object>) results.get('days');
        return daysForecast;

    }
    private static DaysWithForecast setDayCondition(Object conditionObject){
        String condition = String.valueOf(conditionObject);
        DaysWithForecast day = new DaysWithForecast();
        if(condition == 'rain'){
            day.isItRain = true;
        }else if(condition == 'clear-day'){
            day.isItSun = true;
        }else if(condition == 'partly-cloudy-day'){
            day.isItParticalyCloudy = true;
        }else{
            day.isItCloudy = true;
        }
        return day;
    }

    private static String setTemperatureInFarengate(Object temperatureObject){
        String temperature = String.valueOf(temperatureObject) + ' ℉';
        return temperature;
    }

    private static String setTemperatureInCelsium(Object temperatureObject){
        String temperature = String.valueOf(temperatureObject);
        Decimal decimalTemperature = decimal.valueOf(temperature);
        decimalTemperature = (decimalTemperature - 32.0)/1.8;
        decimalTemperature = decimalTemperature.setscale(1);
        String result = String.valueof(decimalTemperature) + ' °C';
        return result;
    }
    
}

public with sharing class Weather {

    @AuraEnabled(cacheable =true)
    public static List<DaysWithForecast> getDaysWithForecast(){
        List<Object> daysForecast = getForecastFor15Days();
        List<DaysWithForecast> daysWithForecast = new List<DaysWithForecast>();
        for(Object oneDayForecast: daysForecast) {
            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(oneDayForecast));
            DaysWithForecast day = setDayCondition(String.valueof(m.get('icon')));
            day.dateWeather = setDayOfWeekFromStringDate(String.valueof(m.get('datetime')));
            day.temp = String.valueof(m.get('temp'));
            daysWithForecast.add(day);
        }   
        return daysWithForecast;
    }
    //From 12-05-2022 to 05/12/2022
    private static String setDayOfWeekFromStringDate(String stringDate){
        List<String> splitedDate = stringDate.split('-');
        String replacedDate = splitedDate[1]+'/'+splitedDate[2]+'/'+splitedDate[0];
        Date rightDate = date.parse(replacedDate);
        Datetime rightDateTime = (DateTime)rightDate;
        String dayOfWeek = rightDateTime.format('EEE');
        return dayOfWeek;
    }
    private static List<Object> getForecastFor15Days(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Minsk?key=LRV3AVMAPFWEKN9WV7XFVZEEP');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> daysForecast = (List<Object>) results.get('days');
        return daysForecast;

    }
    private static DaysWithForecast setDayCondition(String condition){
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
}

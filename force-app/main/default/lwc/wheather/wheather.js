import { LightningElement, track, wire } from 'lwc';
import rain from '@salesforce/resourceUrl/raingif';
import sun from '@salesforce/resourceUrl/sungif';
import cloudy from '@salesforce/resourceUrl/cloudygif';
import cloud from '@salesforce/resourceUrl/cloudgif';
const weekday = ["Sun","Mon","Tue","Wed","Thur","Fri","Sat"];
import getDaysWithForecast from "@salesforce/apex/Weather.getDaysWithForecast";


export default class Wheather extends LightningElement {
    @wire(getDaysWithForecast,{FarenOrCels:'$value', location:'$LocationValue'})
    weatherdays;
    rain = rain;
    cloud = cloud;
    cloudy = cloudy;
    sun = sun;
    value = 'C';
    LocationValue = 'Minsk';

    get options() {
        return [
            { label: '℉', value: 'F' },
            { label: '°C', value: 'C' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    handleLocationChange(event){
        this.LocationValue = event.target.value;
     }


}
import { LightningElement, track, wire } from 'lwc';
import rain from '@salesforce/resourceUrl/raingif';
import sun from '@salesforce/resourceUrl/sungif';
import cloudy from '@salesforce/resourceUrl/cloudygif';
import cloud from '@salesforce/resourceUrl/cloudgif';
const weekday = ["Sun","Mon","Tue","Wed","Thur","Fri","Sat"];
import getDaysWithForecast from "@salesforce/apex/Weather.getDaysWithForecast";


export default class Wheather extends LightningElement {
    @wire(getDaysWithForecast)
    weatherdays;
    rain = rain;
    cloud = cloud;
    cloudy = cloudy;
    sun = sun;


}
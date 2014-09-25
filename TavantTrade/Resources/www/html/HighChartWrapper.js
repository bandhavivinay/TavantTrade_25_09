function addChart(chartType, symbol, width, height, duration, loadVolumeChart, freq){

//var addChart = function(){
   // freq = '1mon';
   // chartType = 'candlestick';
   // loadVolumeChart = true;
	//duration =  360;
   // symbol = 6;
//    var chartSize = '{ \'width\' = 428, \'height\'= 328 }';//"['width':50,'height':50]";
    
	// Ti.API.info('here-----------:'+symbol+ 'dimensions: '+width +'x'+ height);
	// console.log(jQuery);
	(function($){
     var chart;
     var year = new Date().getFullYear();
     var c=[],d=[],vol=[],i=0;
     console.log('here 2');
     
     
    // http://192.168.146.216:8085/chart/quote?frequency=1mon&year=2014&exchange=1&symbol=6
     var url= 'http://192.168.146.216:8085/chart/quote?frequency=1mon&year=2014&exchange=1&symbol=6';
     
     //changed to the exposed IP ....
     
   //  var url='http://121.240.130.118:8085/chart/quote?frequency='+freq+'&year='+year+'&exchange=1&symbol='+symbol;
     
     $.get(url, function(csv) {

           var lines = csv.split('\nvalues');
           
           var groupingUnits = [['week',[1]],['month',[1,2,3,4,6]]];
           // var groupingUnits = [['week',[1]],['month',[1,6]]];
           
           $.each(lines[1].split('\n'), function(lineNo, line) {
                  var items=line.split(',');
                  
                  if(items.length>1){
                  d.push([
                          parseInt(items[0]), //date
  			 		      parseInt(items[1]), //open
                          parseInt(items[3]), //high
                          parseInt(items[4]), //low
                          parseInt(items[2]) //close
                          ]);
                  if(loadVolumeChart){ // load volume chart
                  vol.push([
          					parseInt(items[0]), //date
          					parseInt(items[5]) //volume
                            ]);
                  }
                  }
                  
                  //alert("D:"+d+"Count:"+d.count);
                  });
           
           
           //        console.log('massaged DATA: ad lenth is'+d.length);
           //        console.log('here 3');
           //$.getJSON('http://www.highcharts.com/samples/data/jsonp.php?filename=new-intraday.json&callback=?', function(d) {
           // create the chart
          // alert("yAxisArray");
           
           var yAxisArray = [
                             {
                             top:0,
                             height:Math.round(height*.58), //
                             opposite:true,
                             labels: {
                             style: {
                             color: '#FFFFFF',
                             fontWeight: 'bold'
                             }
                             }
                             }];
           
           
           if(loadVolumeChart){
           yAxisArray.push(
                           {
                           top:Math.round(height*.60),
                           height:Math.round(height*.20),
                           offset:1,
                           lineWidth:2,
                           }
                           );
           }
           
           
           var seriesArray = [
                              {
                              name : '',
                              data : d,
                              type : chartType,
                              tooltip: {
                              valueDecimals: 2
                              },
                              //gapSize: 5,
                              fillColor : {
                              linearGradient : [255, 255, 255, 255],
                              stops : [
                                       [0, Highcharts.getOptions().colors[0]],
                                       [1, 'rgba(2,2,2,2)']
                                       ]
                              },
                              
                              
                              // dataGrouping:{
                              // units:groupingUnits,
                              // smoothed:true,
                              // }
                              }
                              ];
           
           
           if(loadVolumeChart){
           seriesArray.push(
                            {
                            name: 'Volume',
                            type:'column',
                            
                            data:vol,
                            yAxis:1,
                            // dataGrouping:{
                            // units:groupingUnits,
                            // smoothed:true,
                            // }
                            }
                            );
           }
           
           chart = new Highcharts.StockChart({
                                             chart: {
                                             renderTo:'container',
                                              zoomType:'xy',
                                              panning:true,
                                             backgroundColor: 'white',
                                             height: height,
                                             width: width,
                                             },
                                             //zoomType:"xy",
                                             tooltip: {
                                             formatter:function(){
                                             var tip = '<b>Date:' + Highcharts.dateFormat('%d-%m-%y',this.x) + '</b>';
                                             $.each(this.points, function(i,point){
                                                    tip+='<br/>' + this.point.series.name + ':' + Math.round(point.y);
                                                    });
                                             return tip;
                                             },
                                             enabled: true,
                                             positioner: function () {
                                             return { x: 5, y: 0 };
                                             },
                                             backgroundColor: '#fff',
                                             borderColor: 'none',
                                             borderWidth: 1,
                                             shared:true
                                             
                                             },
                                             
                                             plotOptions: {
                                             ohlc: {
                                             color: '#1192cc',
                                             lineWidth: 2,
                                             },
                                             candlestick : {
                                             color: '#1192cc',
                                             upColor: 'brown',
                                             upLineColor:'brown',
                                             lineColor:'#1192cc'
                                             
                                             },
                                             area: {
                                             color: '#1192cc',
                                             fillColor: 'white',
                                             },
                                             line: {
                                             color: '#1192cc',
                                             },
                                             series: {
                                             cursor: 'pointer',
                                             point: {
                                             events: {
                                             click: function() {
                                             if(chartType=='line'  ||chartType=='area'){
                                             hs.htmlExpand(null, {
                                                           pageOrigin: {
                                                           x: this.pageX,
                                                           y: this.pageY
                                                           },
                                                           outlineType : null,
                                                           
                                                           align: 'center',
                                                           headingText:'<span style="color: white;">'+this.series.name+'</span>',
                                                           
                                                           maincontentText: Highcharts.dateFormat('%A, %b %e,%H:%M', this.x) +':<br/> '+
                                                           symbol+':'+this.y,
                                                           width: 200
                                                           
                                                           });
                                             }
                                             else{
                                             hs.htmlExpand(null, {
                                                           pageOrigin: {
                                                           x: this.pageX,
                                                           y: this.pageY
                                                           },
                                                           outlineType : null,
                                                           headingText: '<span style="color: white;">'+this.series.name+'</span>',
                                                           align: 'center',
                                                           maincontentText:Highcharts.dateFormat('%A, %b %e,%H:%M', this.x) +'<br/> open:'+this.open+'<br/>high: '+ '<span style="color: green;">'+this.high+'</span>'+'<br/>low: '+'<span style="color: red;">'+this.low+'</span>'+'<br/>close: '+this.close,
                                                           width: 200
                                                           });
                                             }
                                             }
                                             }
                                             },
                                             marker: {
                                             lineWidth: 1
                                             }
                                             }
                                             
                                             },
                                             xAxis: {
                                             labels: {
                                             style: {
                                             color: '#FFFFFF',
                                             fontWeight: 'bold'
                                             }                       },
                                             },
                                             yAxis: yAxisArray,
                                             title : {
                                             text : '',
                                             style: {
                                             color: '#2c93dc',
                                             fontWeight: 'bold'
                                             },
                                             },
                                             rangeSelector : {
                                             buttons: [{
                                                       type: 'day',
                                                       count: 1,
                                                       text: '1d'
                                                       },
                                                       {
                                                       type: 'day',
                                                       count: 5,
                                                       text: '5d'
                                                       }, 
                                                       {
                                                       type: 'week',
                                                       count: 1,
                                                       text: '1w'
                                                       }, 
                                                       {
                                                       type: 'month',
                                                       count: 1,
                                                       text: '1m'
                                                       },
                                                       {
                                                       type: 'month',
                                                       count: 6,
                                                       text: '6m'
                                                       },
                                                       {
                                                       type: 'year',
                                                       count: 1,
                                                       text: '1Yr'
                                                       }],
                                             buttonTheme:{
                                             style:{
                                             visibility: 'hidden',
                                             }
                                             },
                                             labelStyle:{
                                             visibility: 'hidden',
                                             },
                                             
                                             selected : freq,
                                             inputEnabled:false,
                                             enabled:true,         
                                             visibility: 'hidden',                  
                                             },
                                             
                                             navigator : {
                                             enabled: false,
                                             height  : 20,
                                             maskFill:  {
                                             linearGradient: {
                                             x1: 0,
                                             y1: 0,
                                             x2: 1,
                                             y2: 1
                                             },
                                             stops: [
                                                     [0, 'rgb(52, 52, 52)'],
                                                     [1, 'rgb(52, 52, 52)']
                                                     ]
                                             },  
                                             },
                                             
                                             series : seriesArray,
                                             
                                             scrollbar:
                                             {
                                             barBackgroundColor:'white',
                                             barBorderRadius:7,
                                             barBorderWidth:0,
                                             buttonBackgroundColor:'white',
                                             buttonBorderRadius:0,
                                             buttonBordeWidth:7,
                                             trackBackgroundColor:'none',
                                             trackBorderWidth:1,
                                             trackBorderRadius:8,
                                             trackBorderColor:'#CCC',
                                             height:15,
                                             rifleColor:'#000'
                                             }
                                             });
           url = "Chart:success";
           window.location = url;
           //loadedChart();
           }
           ).error(function(HttpRequestCode,textStatus,errorThrown){
                   //loadedChart();
                   //errorMessage();
                   url = "Chart:Error";
                   window.location = url;
                   //alert("Error Received");

                   });
     //chart.rangeSelector.destroy();
     }(jQuery));	
	// console.log('reached end of add charts function');
};

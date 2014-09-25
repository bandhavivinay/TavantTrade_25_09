// Class to represent a row in the seat reservations grid
function WatchlistCell(idNo,symbol,subscriptionKey,companyname,last,vol,change,changePer,bid,ask,instType,exchange,high,low,time) {
    var self = this;
    self.idNo	=	ko.observable(idNo);
    self.updateCellBg = ko.observable('url("../../images/green_sq.png") repeat-y left');
    self.symbol = ko.observable(symbol);
    self.subscriptionKey = ko.observable(subscriptionKey);
    self.companyName = ko.observable(companyname);
    self.instrumentType = ko.observable(instType); 
    self.exchange = ko.observable(exchange);
    
    self.last = ko.observable(last);
    self.vol = ko.observable(vol);
    self.updateLastColor = ko.observable('#3F9E0F');
    self.change = ko.observable(change);
    if(changePer > 0){
    	self.changePer = ko.observable(changePer+'%');
    }else{
    	self.changePer = ko.observable('0%');
    }
    
    self.updateChangeColor = ko.observable('#3F9E0F');
    
    self.bid = ko.observable(bid);
    self.ask = ko.observable(ask);
    self.high = ko.observable(high);
    self.low = ko.observable(low);
    self.updateTime = ko.observable(time);
}

// Overall viewmodel for this screen, along with initial state
/*
 * The function used to load the model (webview table) with the initial data
 * parameter - symbolArray: array holding symbols data (as a WatchlistCell object) retreived from the API call
 */
function WatchlistViewModel() {
    var self = this;
   // self.symbols = symbolArray;
    
   	/*
   	 *  Dummy test data (hardcoded array)
   	 */
    // self.symbols = ko.observableArray();
    // for(var i = 0; i < symbolArray.length ; i++){	    
	    // self.symbols.push(new WatchlistCell(i,symbolArray[i].symbol,0,0,0,0,0,0,0));
   	// }
    self.symbols = ko.observableArray(
    	// [
        // new WatchlistCell(1,"ACROW", 200.56, 375.86,278.5,368.34,200.80,368.34,200.80),
        // new WatchlistCell(2,"LTE", 200.56, 375.86,278.05,368.34,200.80,368.34,200.80),
		// new WatchlistCell(3,"TATA", 250.56, 370.20,278.50,368.34,240.80,368.34,200.80),
		// new WatchlistCell(4,"BATA", 250.56, 270.20,260.50,368.34,240.80,368.34,200.80),
		// new WatchlistCell(5,"ATTA", 250.56, 375.80,278.50,368.34,240.80,368.34,200.80),
		// new WatchlistCell(6,"WATA", 250.56, 370.20,278.50,368.34,240.80,368.34,200.80),
		// new WatchlistCell(7,"PATA", 250.56, 370.20,278.50,368.34,240.80,368.34,200.80),
    // ]
    );

    
    /*
     *  function used to update the symbol data. this is called on the UpdateDataEvent of diffusion client
     *  parameter - symbData: the symbol object (as a WatchlistCell object) in the array that needs to be updated
     */
    self.updateSymbol = function(symbData){
    	    	
    	var wlArray = self.symbols();
    	Ti.API.debug('Update meant to happen here: LENGTH OF ARRAY ' + symbData);
    	for(var i = 0; i < wlArray.length; i++){
    		// Ti.API.debug('Original: ' + wlArray[i].subscriptionKey());
    		// Ti.API.debug('Updated: ' + symbData[0]);
    		if(wlArray[i].subscriptionKey() == symbData[0]){
    			
    			var newLast = symbData[1];
    			
    			var changeValue = (newLast - wlArray[i].last()).toFixed(2);
    			// alert(changeValue);
    			// alert(wlArray[i].last());
    			if(wlArray[i].last() != 0){
					var percentage = (changeValue/wlArray[i].last()).toFixed(2);
					wlArray[i].changePer(percentage+'%');
				}
				
				if(changeValue < 0){
					wlArray[i].updateLastColor('#DA2C2C');
				}else{
					wlArray[i].updateLastColor('#3F9E0F');
				}
				wlArray[i].last(newLast);
				wlArray[i].vol(symbData[2]);
				
				
				//var newChange = changeValue;
				if(symbData[3] == "-"){
					wlArray[i].updateChangeColor('#DA2C2C');
					wlArray[i].updateCellBg('url("../../images/red_sq.png") repeat-y left');
				}else{
					wlArray[i].updateChangeColor('#3F9E0F');
					wlArray[i].updateCellBg('url("../../images/green_sq.png") repeat-y left');
				}
				wlArray[i].change(symbData[3] + symbData[4]);
				
				
    			wlArray[i].bid(symbData[5]);
				wlArray[i].ask(symbData[6]);
				wlArray[i].high(symbData[7]);
				wlArray[i].low(symbData[8]);
				var dateObj = new Date(symbData[9]*1000);
				wlArray[i].updateTime('Date: '+dateObj.getDate()+'/'+dateObj.getMonth()+'/'+dateObj.getFullYear());				
    		}
    	}
    	
    };
    
    self.removeSymbols = function(e){    	
    	Ti.API.debug('----removing all the symbols from knockout----');
    	self.symbols.removeAll();     	
    };
    // self.testme=function(e){
    	// //alert('clickckkkkkkkkkk');
    	// self.symbols.removeAll();
    // }
    
    self.getLength=function(e){
    	return self.symbols().length;
    }
    
    self.removeAllSymbols=function(e){
       	self.symbols.removeAll();
    }
    
    self.mapNewKeys=function(e){	
    	var dateObj = new Date();
    	var time =  'Date: ' + dateObj.getDate()+'/'+dateObj.getMonth()+'/'+dateObj.getFullYear(); 
      for(var i=0; i < e.length; i++){		
			self.symbols.push(new WatchlistCell(i,e[i].symbol,e[i].subscriptionKey,e[i].displayName,0,0,0,0,0,0,e[i].instrumentType,e[i].exchange,0,0,time));
	  }	
    }
    
    
	/* 
	 * function to test update for the hardcoded array
	 */
    // self.randomizer = function(){ 
		// var wlArray = self.symbols();		
		// var i = Math.floor(Math.random() *  wlArray.length);	
		// var newLast = (Math.random()*10 + 300).toFixed(2);
		// var changeValue = newLast - wlArray[i].last();
		// if(changeValue < 0){
			// wlArray[i].updateLastColor('red');
		// }else{
			// wlArray[i].updateLastColor('green');
		// }
		// wlArray[i].last(newLast);
// 		
		// var newChange = changeValue;
		// if(newChange < 0){
			// wlArray[i].updateChangeColor('red');
			// wlArray[i].updateCellBg('url("../../images/red_sq.png") repeat-y left');
		// }else{
			// wlArray[i].updateChangeColor('green');
			// wlArray[i].updateCellBg('url("../../images/green_sq.png") repeat-y left');
		// }
		// wlArray[i].change(newChange.toFixed(2));
		// wlArray[i].high((Math.random()*10 + 300).toFixed(2));
		// wlArray[i].low((Math.random()*10 + 300).toFixed(2));
		// wlArray[i].bid((Math.random()*10 + 300).toFixed(2));
		// wlArray[i].ask((Math.random()*10 + 300).toFixed(2));	
    // };
}

 //ko.applyBindings(new WatchlistViewModel());

/*
 * full functionality to be implemented (when drilling down to a particular symbol)
 */
// function alertId(row){
	// //alert('click');
	// var values = row.cells[0].getElementsByTagName('div');
	// var subKey = values[1].innerHTML;
	// var symbol = values[2].innerHTML;
	// var company = values[3].innerHTML;
	// var instrumentType = values[4].innerHTML;
	// var exchange = values[5].innerHTML;
	// // alert(temp[0].innerHTML); // placeholder code
	// // Ti.App.fireEvent("app:openquotes",{'subscriptionKey':subKey,'symbol':symbol,'companyName':company});
	// Ti.App.fireEvent("app:opentradescreen",{'subscriptionKey':subKey,'symbol':symbol,'companyName':company,'instType':instrumentType,'exchange':exchange});
// };
function goToTrade(tdData){
	// alert('TD clicked: /n ' + tdData.parentNode.innerHTML);
	var symData = tdData.parentNode;
	var values = symData.cells[0].getElementsByTagName('div');
	var subKey = values[1].innerHTML;
	var symbol = values[2].innerHTML;
	var company = values[3].innerHTML;
	var instrumentType = values[4].innerHTML;
	var exchange = values[5].innerHTML;
	
	Ti.App.fireEvent("app:opentradescreen",{'subscriptionKey':subKey,'symbol':symbol,'companyName':company,'instType':instrumentType,'exchange':exchange});
}
function goToQuote(tdData){
	// alert('Rest of TD clicked: /n ' + tdData.parentNode.innerHTML);
	var symData = tdData.parentNode;
	var values = symData.cells[0].getElementsByTagName('div');
	var subKey = values[1].innerHTML;
	var symbol = values[2].innerHTML;
	var company = values[3].innerHTML;
	var instrumentType = values[4].innerHTML;
	var exchange = values[5].innerHTML;
	// alert(temp[0].innerHTML); // placeholder code
	// Ti.App.fireEvent("app:openquotes",{'subscriptionKey':subKey,'symbol':symbol,'companyName':company});
	Ti.App.fireEvent("app:openquotescreen",{'subscriptionKey':subKey,'symbol':symbol,'companyName':company,'instType':instrumentType,'exchange':exchange});
}

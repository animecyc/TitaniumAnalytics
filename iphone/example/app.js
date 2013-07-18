var Analytics = require('com.animecyc.analytics'),
	win = Ti.UI.createWindow({
		backgroundColor : 'white',
		layout : 'vertical'
	}),
	trackBtn = Ti.UI.createButton({
		title : 'Track Pageview'
	}),
	eventBtn = Ti.UI.createButton({
		title : 'Track Event'
	}),
	transactionButton = Ti.UI.createButton({
		title : 'Track Transaction'
	});

Analytics.debug = true;
Analytics.dispatchInterval = 10;
Analytics.trackUncaughtExceptions = true;
Analytics.optOut = false;

var tracker = Analytics.getTracker("UA-XXXXXXXX-X"),
	randomNumber = function () {
		return (Math.random() * 11 * Math.random() * 11) | 0
	};

trackBtn.addEventListener('click', function () {
	tracker.trackScreen('Page ' + randomNumber());
});

eventBtn.addEventListener('click', function () {
	tracker.trackEvent({
		event : 'Test Event',
		action : 'Test Action',
		label : 'Test Label',
		value : randomNumber()
	});
});

transactionButton.addEventListener('click', function () {
	var transaction = Analytics.createTransaction("Transaction" + randomNumber(), {
		affiliation : "Test Affiliation",
		tax : 0.6,
		shipping : 5.13,
		revenue : 0
	});

	transaction.addItem({
		sku : 'ITM' + randomNumber(),
		name : 'Item 1',
		category : 'Test Items',
		price : 2.12,
		quantity : 1
	});

	transaction.setRevenue(2.12);
	tracker.trackTransaction(transaction);
});

win.add(eventBtn);
win.add(trackBtn);
win.add(transactionButton);
win.open();
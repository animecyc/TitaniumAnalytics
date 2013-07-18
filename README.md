# TitaniumAnalytics Module

A full implementation of the Google Analytics SDK. As of this writing the SDK is at v2.0b4 and is not compatible with the legacy application analytics profiles. This implementation supports multiple trackers at the same time so long as all trackers adhere to Google Analytics quotas and limitations on aggregate tracking.

## Usage

	var Analytics = require("com.animecyc.analytics"),
		tracker = Analytics.getTracker('UA-XXXXXXX-X');

		Analytics.setDebug(true);
		tracker.trackScreen('Home');

## Module Reference

- - -

### Analytics.getTracker(uaCode);

Get an instance of a tracker and creates it if it does not exist. Calling `getTracker` on the same UA code will return a reference to the tracker.

- uaCode (String):
	- The tracker identifier from a compatible google analytics profile.

### Analytics.getDefaultTracker();

Get the default (if not set the first) tracker reference.

*This method takes no paramters.*

### Analytics.createTransaction(transactionId, transactionOptions);

Create a transaction (ECommerce) to be sent via a tracker.

- transactionId (String):
	- A unique string identifiing the transaction.
- transactionOptions (Object):
	- An object containing the following:
		- affiliation (String)
		- tax (Float)
		- shipping (Float)
		- revenue (Float)

### Analytics.setDebug(debug);

Set the debug flag, will result in messages being logged to the console. Ensure you don't leave this enabled for production.

- debug (Boolean):
	- Debug status flag

### Analytics.setDispatchInterval(dispatchInterval);

Set the dispatch interval; All hits are queued and will be sent on an interval firing on the interval set by this method. By default queues are dispatched every 120 seconds.

- dispatchInterval (Float):
	- Interval at which hits are dispatched automatically.

### Analytics.setTrackUncaughtExceptions(trackUncaught);

Track exceptions not caught from the application. Exceptions caught by means of this flag being set to `true` are always reported as fatal.

- trackUncaught (Boolean):
	- Boolean flag to catch uncaught exceptions.

### Analytics.setOptOut(optOut);

If set to true, all trackers will cease to dispatch anything tracked.

- optOut (Boolean):
	- Boolean flag to globally opt-out of all analytics tracking.

## Tracker Reference

- - -

### Tracker.trackScreen(screenName);

Track an individual screen, optionally send a screen name with the hit.

- screenName (String):
	- String containing the name of the screen being hit.

### Tracker.trackEvent(eventOptions);

- eventOptions (Object):
	- An object containing the following:
		- category (String)
		- action (String)
		- label (String)
		- value (Float)

### Tracker.trackException(exceptionOptions);

- exceptionOptions (Object):
	- An object containing the following:
		- fatal (Boolean)
		- description (String)

### Tracker.trackSocial(socialOptions);

- socialOptions (Object):
	- An object containing the following:
		- social (String)
		- action (String)
		- target (String)

### Tracker.trackTime(timingOptions);

- timingOptions (Object):
	- An object containing the following:
		- category (String)
		- interval (Integer)
		- name (String)
		- label (String)

### Tracker.setAnonymize(anonymize);

- anonymize (Boolean):
	- If set to `true` the tracker will anonymize the users session. Typically this will scramble the last octets of a users IP address.

### Tracker.setUseHttps(useHttps);

- useHttps (Boolean):
	- If set to `true` hits will be sent over the HTTPS protocol. This defaults to `true`.

### Tracker.setSampleRate(sampleRate);

- sampleRate (Float):
	- This will limit the number of hits sent to Google Analytics. It can range from `0` to `100`. This is useful if your application has a large number of users.

### Tracker.setSessionTimeout(sessionTimeout);

- sessionTimeout (Integer):
	- An integer used to set the length of time a session will persist.

### Tracker.setCampaignUrl(campaignUrl);

- campaignUrl (String):
	- A string containing the URL used in analytics campaigns.

### Tracker.setReferrerUrl(referrerUrl);

- referrerUrl (String):
	- A string containing the URL used as a referrer, typically used in a campaign to track where people are coming from.

## Transaction Reference

- - -

### setTax(tax)

- tax (Float):
	- The tax-rate for the transaction.

### setShipping(shipping)

- shipping (Float):
	- The amount of shipping for the transaction.

### setRevenue(revenue)

- revenue (Float):
	- The total revenue for the transaction. This must be updated manually as adding items will not automatically increment this value.

### addItem(itemOptions)

- itemOptions (Object):
	- An object containing the following:
		- sku (String)
		- name (String)
		- category (String)
		- price (Float)
		- quantity (Integer)

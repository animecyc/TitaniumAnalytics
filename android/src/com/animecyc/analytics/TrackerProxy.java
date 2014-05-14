package com.animecyc.analytics;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.util.TiConvert;

import com.google.analytics.tracking.android.Tracker;
import com.google.analytics.tracking.android.Transaction;

@Kroll.proxy
public class TrackerProxy extends KrollProxy
{
	private Tracker tracker;
	private long sessionTimeout = 30L;
	private String campaignUrl;
	private String referrerUrl;
	private Boolean anonymize;
	private Boolean useHttps;
	private double sampleRate;

	public TrackerProxy(String accountId)
	{
		super();

		tracker = TitaniumAnalyticsModule.analyticsInstance.getTracker(accountId);
	}

	public TrackerProxy()
	{
		super();

		tracker = TitaniumAnalyticsModule.analyticsInstance.getDefaultTracker();
	}

	public void startNewSessionIfApplicable(Long idleMinutes)
	{
		if (idleMinutes >= sessionTimeout)
		{
			tracker.setStartSession(true);

			debugMessage("Starting a new session for tracker: " + tracker.getTrackingId());
		}
		else
		{
			debugMessage("Tracker " + tracker.getTrackingId() + " session has not expired.");
		}
	}

	@Kroll.method
	public void trackScreen(@Kroll.argument(optional=true) String screenName)
	{
		tracker.sendView(screenName);

		debugMessage("Queueing screen hit with name: " + screenName);
	}

	@Kroll.method
	public void trackTransaction(TransactionProxy transactionProxy)
	{
		Transaction transaction = transactionProxy.buildTransaction();

		tracker.sendTransaction(transaction);

		debugMessage("Queueing transaction hit with ID: " + transaction.getTransactionId());
	}

	@Kroll.method
	public void trackEvent(KrollDict eventOptions)
	{
		Long longValue = (eventOptions.get("value") != null) ? Long.parseLong(TiConvert.toString(eventOptions.get("value"))) : null;
		
		tracker.sendEvent(
			TiConvert.toString(eventOptions.get("category")),
			TiConvert.toString(eventOptions.get("action")),
			TiConvert.toString(eventOptions.get("label")),
			longValue
		);

		debugMessage("Queueing event hit with arguments: " + eventOptions);
	}

	@Kroll.method
	public void trackException(KrollDict exceptionOptions)
	{
		tracker.sendException(
			TiConvert.toString(exceptionOptions.get("description")),
			TiConvert.toBoolean(exceptionOptions.get("fatal"))
		);

		debugMessage("Queueing exception hit with arguments: " + exceptionOptions);
	}

	@Kroll.method
	public void trackSocial(KrollDict socialOptions)
	{
		tracker.sendSocial(
			TiConvert.toString(socialOptions.get("social")),
			TiConvert.toString(socialOptions.get("action")),
			TiConvert.toString(socialOptions.get("target"))
		);

		debugMessage("Queueing social hit with arguments: " + socialOptions);
	}

	@Kroll.method
	public void trackTime(KrollDict timeOptions)
	{
		tracker.sendTiming(
			TiConvert.toString(timeOptions.get("category")),
			Long.parseLong(TiConvert.toString(timeOptions.get("interval"))),
			TiConvert.toString(timeOptions.get("name")),
			TiConvert.toString(timeOptions.get("label"))
		);

		debugMessage("Queueing timing hit with arguments: " + timeOptions);
	}

	@Kroll.method
	@Kroll.getProperty
	public Integer getSessionTimeout()
	{
		return TiConvert.toInt(sessionTimeout);
	}

	@Kroll.method
	@Kroll.setProperty
	public void setSessionTimeout(Integer sessionTimeout)
	{
		this.sessionTimeout = sessionTimeout.longValue();

		debugMessage("Setting session timeout to: " + sessionTimeout);
	}

	@Kroll.method
	@Kroll.getProperty
	public double getSampleRate()
	{
		return sampleRate;
	}

	@Kroll.method
	@Kroll.setProperty
	public void setSampleRate(double sampleRate)
	{
		tracker.setSampleRate(this.sampleRate = sampleRate);

		debugMessage("Setting sample rate to: " + sampleRate);
	}

	@Kroll.method
	@Kroll.getProperty
	public Boolean getAnonymize()
	{
		return anonymize;
	}

	@Kroll.method
	@Kroll.setProperty
	public void setAnonymize(Boolean anonymize)
	{
		tracker.setAnonymizeIp(this.anonymize = anonymize);

		debugMessage("Anonymous sessions has been " + (anonymize ? "enabled" : "disabled"));
	}

	@Kroll.method
	@Kroll.getProperty
	public String getReferrerUrl()
	{
		return referrerUrl;
	}

	@Kroll.method
	@Kroll.setProperty
	public void setReferrerUrl(String referrerUrl)
	{
		tracker.setReferrer(this.referrerUrl = referrerUrl);

		debugMessage("Setting referrer URL to: " + referrerUrl);
	}

	@Kroll.method
	@Kroll.getProperty
	public String getCampaignUrl()
	{
		return campaignUrl;
	}

	@Kroll.method
	@Kroll.setProperty
	public void setCampaignUrl(String campaignUrl)
	{
		tracker.setCampaign(this.campaignUrl = campaignUrl);

		debugMessage("Setting campaign URL to: " + campaignUrl);
	}

	@Kroll.method
	@Kroll.getProperty
	public Boolean getUseHttps() {
		return useHttps;
	}

	@Kroll.method
	@Kroll.setProperty
	public void setUseHttps(Boolean useHttps) {
		tracker.setUseSecure(this.useHttps = useHttps);

		debugMessage("Use of HTTPS has been " + (useHttps ? "enabled" : "disabled"));
	}

	private void debugMessage(String message)
	{
		TitaniumAnalyticsModule.debugMessage(message);
	}
}
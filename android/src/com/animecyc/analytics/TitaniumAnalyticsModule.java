package com.animecyc.analytics;

import java.lang.Thread.UncaughtExceptionHandler;
import java.util.ArrayList;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiApplication;

import android.app.Activity;

import com.google.analytics.tracking.android.ExceptionReporter;
import com.google.analytics.tracking.android.GAServiceManager;
import com.google.analytics.tracking.android.GoogleAnalytics;
import com.google.analytics.tracking.android.Tracker;

@Kroll.module(name="TitaniumAnalytics", id="com.animecyc.analytics")
public class TitaniumAnalyticsModule extends KrollModule
{
	private static final String TAG = "TitaniumAnalyticsModule";
	public static boolean DEBUGGING;
	public static Integer DISPATCH_INTERVAL;
	public static boolean OPT_OUT;
	public static boolean TRACK_EXCEPTIONS;
	public static GoogleAnalytics analyticsInstance;
	public final TiApplication moduleContext;
	private final UncaughtExceptionHandler defaultThreadExceptionHandler;
	private ArrayList<TrackerProxy> trackers = new ArrayList<TrackerProxy>();
	private static Long lastPausedMillis = 0L;
	
	public TitaniumAnalyticsModule()
	{
		super();
		
		moduleContext = TiApplication.getInstance();
		analyticsInstance = GoogleAnalytics.getInstance(moduleContext);
		defaultThreadExceptionHandler = Thread.getDefaultUncaughtExceptionHandler();
		
		DEBUGGING = false;
		TRACK_EXCEPTIONS = false;
		OPT_OUT = false;
		DISPATCH_INTERVAL = 120;
	}
	
	@Override
	public void onStart(Activity activity)
	{
		if (lastPausedMillis > 0)
		{
			Long elapsedMinutes = ((getUnixTime() - lastPausedMillis) / 1000) / 60;
			
			for (int i = 0; i < trackers.size(); i++) {
				trackers.get(i).startNewSessionIfApplicable(elapsedMinutes);
			}
		}
		
		super.onStart(activity);
	}
	
	@Override
	public void onPause(Activity activity)
	{
		lastPausedMillis = getUnixTime();
		
		super.onPause(activity);
	}
	
	@Kroll.method
	public KrollProxy getTracker(String accountId)
	{
		TrackerProxy tracker = new TrackerProxy(accountId);
		
		trackers.add(tracker);
		
		debugMessage("Getting tracker with ID: " + accountId);
		
		return tracker;
	}
	
	@Kroll.method
	public KrollProxy createTransaction(String transactionId, @Kroll.argument(optional=true) KrollDict transactionOptions)
	{
		TransactionProxy transaction;
		
		if (transactionOptions != null)
		{
			transaction = new TransactionProxy(transactionId, transactionOptions);
		}
		else
		{
			transaction = new TransactionProxy(transactionId);
		}
		
		debugMessage("Creating transaction with ID: " + transactionId);
		
		return transaction;
	}
	
	@Kroll.method
	public KrollProxy getDefaultTracker()
	{
		debugMessage("Getting default tracker");
		
		return new TrackerProxy();
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setDebug(boolean debug)
	{
		DEBUGGING = debug;
		
		analyticsInstance.setDebug(DEBUGGING);
		
		debugMessage("Debugging has been " + (DEBUGGING ? "enabled" : "disabled"));
	}
	
	@Kroll.method
	@Kroll.getProperty
	public boolean getDebug()
	{
		return DEBUGGING;
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setDispatchInterval(Integer dispatchInterval)
	{
		DISPATCH_INTERVAL = dispatchInterval;
		
		GAServiceManager.getInstance().setDispatchPeriod(DISPATCH_INTERVAL);
		
		debugMessage("Dispatch interval has been set to: " + DISPATCH_INTERVAL);
	}
	
	@Kroll.method
	@Kroll.getProperty
	public Integer getDispatchInterval()
	{
		return DISPATCH_INTERVAL;
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setTrackUncaughtExceptions(boolean trackExceptions)
	{
		Tracker defaultTracker = analyticsInstance.getDefaultTracker();
		
		if (defaultTracker != null)
		{
			if (TRACK_EXCEPTIONS = trackExceptions)
			{
				Thread.setDefaultUncaughtExceptionHandler(new ExceptionReporter(
					defaultTracker,
				    GAServiceManager.getInstance(),
				    Thread.getDefaultUncaughtExceptionHandler(),
				    moduleContext
				));
			}
			else
			{
				Thread.setDefaultUncaughtExceptionHandler(defaultThreadExceptionHandler);
			}
			
			debugMessage("Exception tracking has been " + (TRACK_EXCEPTIONS ? "enabled" : "disabled"));
		}
		else
		{
			debugMessage("A default tracker must be set.");
		}
	}
	
	@Kroll.method
	@Kroll.getProperty
	public boolean getTrackUncaughtExceptions()
	{
		return TRACK_EXCEPTIONS;
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setOptOut(boolean optOut)
	{
		OPT_OUT = optOut;
		
		analyticsInstance.setAppOptOut(OPT_OUT);
		
		debugMessage("Global opt-opt has been " + (OPT_OUT ? "enabled" : "disabled"));
	}
	
	@Kroll.method
	@Kroll.getProperty
	public boolean getOptOut()
	{
		return OPT_OUT;
	}
	
	public static void debugMessage(String message)
	{
		if (DEBUGGING)
		{
			Log.i(TAG, message);
		}
	}
	
	public static Long getUnixTime()
	{
		return System.currentTimeMillis();
	}
}
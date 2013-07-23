package com.animecyc.analytics;

import java.util.ArrayList;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.util.TiConvert;

import com.google.analytics.tracking.android.Transaction;
import com.google.analytics.tracking.android.Transaction.Builder;
import com.google.analytics.tracking.android.Transaction.Item;

@Kroll.proxy
public class TransactionProxy extends KrollProxy {
	private Builder transactionBuilder;
	private long tax = 0L;
	private long revenue = 0L;
	private long shipping = 0L;
	private String affiliation;
	private String transactionId;
	private ArrayList<Item> items = new ArrayList<Item>();
	
	public TransactionProxy(String transactionId, KrollDict transactionOptions)
	{
		super();
		
		initBuilder(transactionId, transactionOptions);
	}
	
	public TransactionProxy(String transactionId)
	{
		super();
		
		initBuilder(transactionId, new KrollDict());
	}
	
	protected void initBuilder(String transactionId_, KrollDict transactionOptions)
	{
		transactionId = transactionId_;
		
		Object _shipping = transactionOptions.get("shipping");
		Object _tax = transactionOptions.get("tax");
		Object _affiliation = transactionOptions.get("affiliation");
		
		if (_shipping != null)
		{
			setShipping(TiConvert.toDouble(_shipping));
		}
		
		if (_tax != null)
		{
			setTax(TiConvert.toDouble(_tax));
		}
		
		if (_affiliation != null)
		{
			setAffiliation(TiConvert.toString(_affiliation));
		}
	}

	public Transaction buildTransaction()
	{
		transactionBuilder = new Transaction.Builder(transactionId, revenue);
		
		transactionBuilder.setAffiliation(affiliation);
		transactionBuilder.setShippingCostInMicros(shipping);
		transactionBuilder.setTotalTaxInMicros(tax);
		
		Transaction transaction = transactionBuilder.build();
		
		for (int i = 0; i < items.size(); i++) {
			transaction.addItem(items.get(i));
		}
		
		return transaction;
	}
	
	@Kroll.method
	public void addItem(KrollDict itemOptions)
	{
		String SKU = TiConvert.toString(itemOptions.get("sku"));
		String name = TiConvert.toString(itemOptions.get("name"));
		String category = TiConvert.toString(itemOptions.get("category"));
		long price = toMicros(TiConvert.toDouble(itemOptions.get("price")));
		long quantity = (long) TiConvert.toDouble(itemOptions.get("quantity"));
		
		Item item = new Transaction.Item.Builder(SKU, name, price, quantity)
			.setProductCategory(category)
			.build();
		
		items.add(item);
	}
	
	@Kroll.method
	@Kroll.getProperty
	public long getTax()
	{
		return tax;
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setTax(double tax)
	{
		this.tax = toMicros(tax);
	}
	
	@Kroll.method
	@Kroll.getProperty
	public long getRevenue()
	{
		return revenue;
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setRevenue(double revenue)
	{
		this.revenue = toMicros(revenue);
	}
	
	@Kroll.method
	@Kroll.getProperty
	public long getShipping()
	{
		return shipping;
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setShipping(double shipping)
	{
		this.shipping = toMicros(shipping);
	}
	
	@Kroll.method
	@Kroll.getProperty
	public String getAffiliation()
	{
		return affiliation;
	}
	
	@Kroll.method
	@Kroll.setProperty
	public void setAffiliation(String affiliation)
	{
		this.affiliation = affiliation;
	}
	
	private long toMicros(double amount)
	{
		return (long) (amount * 1000000);
	}
}
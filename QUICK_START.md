# 🚀 Quick Start - Price Drop Alert System

## ⚡ Get Started in 5 Minutes

### Step 1: Verify Environment Variables
Add these to your `.env` file:
```env
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/cognitive_cart
BREVO_API_KEY=your_brevo_api_key_here
SCRAPER_API_KEY=your_scraper_api_key_here
SERPAPI_KEY=your_serpapi_key_here
```

**Sign up for free:**
- MongoDB: https://www.mongodb.com/cloud/atlas
- Brevo (Email): https://www.brevo.com/
- ScraperAPI: https://www.scraperapi.com/
- SerpAPI: https://serpapi.com/

### Step 2: Start the Server
```bash
node script.js
```

You should see:
```
🔥 Cognitive Cart backend running on port 3000
👉 Open http://localhost:3000 in your browser!
[PRICE MONITOR] Starting initial price check...
MongoDB connected
```

### Step 3: Use the Feature
1. **Search for a product** (e.g., "MacBook Pro")
2. **Click "📊 Watch Price"** on any product
3. **See confirmation**: "Added to watchlist! You'll get email alerts on price drops"
4. **View your watchlist**: http://localhost:3000/watchlist.html

### Step 4: Monitor Price Changes
- System automatically checks prices **every 4 hours**
- When price drops **≥5%**, email is sent to user
- Check your email for price drop alerts
- Max **1 email per product per 24 hours**

---

## 📊 User Dashboard (watchlist.html)

Shows:
- **Total Products**: How many you're watching
- **Price Drops Detected**: How many got alerts  
- **Total Savings**: How much you've saved
- **Price History**: Last 5 snapshots per product
- **Remove Button**: Stop watching anytime

---

## 🔔 Expected Email When Price Drops

**Subject:** 🎉 Price Drop Alert: 5% OFF on "Product Name..."

**Email contains:**
- Product image & details
- Previous price crossed out
- New price in green
- Savings amount & percentage
- Button to view watchlist

---

## 📡 API Endpoints

### Add to Watchlist
```bash
curl -X POST http://localhost:3000/api/watchlist/add \
  -H "Content-Type: application/json" \
  -d '{
    "username": "user@email.com",
    "product": {
      "title": "MacBook Pro M5",
      "price": "159999",
      "image": "https://...",
      "rating": "4.8",
      "store": "Amazon"
    }
  }'
```

### Get Watchlist
```bash
curl http://localhost:3000/api/watchlist/user@email.com
```

### Remove from Watchlist
```bash
curl -X DELETE http://localhost:3000/api/watchlist/YOUR_WATCHLIST_ID
```

---

## 🛠️ Customize Monitoring

### Change Check Frequency
In `api/index.js`, find line 790:
```javascript
// Change from 4 hours to 2 hours
setInterval(monitorPricesScheduled, 2 * 60 * 60 * 1000);
```

### Change Price Drop Threshold
In `api/index.js`, find line 715:
```javascript
// Change from 5% to 3%
if (priceDropPercentage >= 3) {
```

### Change Email Notification Cooldown
In `api/index.js`, find line 745:
```javascript
// Change from 24 hours to 12 hours
Date.now() - lastNotification.timestamp > 12 * 60 * 60 * 1000;
```

---

## 🐛 Debug Tips

### Check if Monitoring Job is Running
Look for in server console:
```
[PRICE MONITOR] Checking X products for price changes...
[PRICE DROP] Notified user@email.com about Product Name
```

### View Database
Use MongoDB Atlas:
1. Go to https://www.mongodb.com/cloud/atlas
2. Click "Browse Collections"
3. Find "cognitive_cart" database
4. Find "watchlist" collection
5. See all watched products and price history

### Test Email Sending
Server logs will show:
```
Brevo API: Sending email to user@email.com
```

If email fails:
- Check BREVO_API_KEY in .env
- Verify email address is correct
- Check Brevo account has credits

---

## ✅ Verification Checklist

- [ ] Server starts without errors
- [ ] Can search products
- [ ] "Watch Price" button appears
- [ ] Can click button and gets confirmation
- [ ] Can load watchlist.html
- [ ] Products appear in watchlist dashboard  
- [ ] MongoDB shows watchlist collection
- [ ] Email address is correct in MongoDB
- [ ] Server logs show "[PRICE MONITOR]" messages
- [ ] Received test email alert

---

## 📚 Full Documentation

See these files for more details:
- **PRICE_TRACKING_GUIDE.md** - Complete feature guide with API docs
- **IMPLEMENTATION_SUMMARY.md** - Technical architecture & code examples
- **api/index.js** - Backend implementation (search for "PRICE TRACKING")

---

## 🔥 Cool Features

✅ **Multi-Store Price Comparison**
   - Monitors Amazon, Flipkart, Google Shopping simultaneously
   
✅ **Smart Email Throttling**
   - Max 1 email per product per 24 hours (prevents spam)
   
✅ **Price History Timeline**
   - Track all price changes over time
   
✅ **Savings Dashboard**
   - See total money saved across all products
   
✅ **Background Processing**
   - Checks prices automatically while you sleep
   
✅ **Zero Configuration**
   - Works out of the box once env vars are set

---

## 🆘 Common Issues

### "No products in watchlist"
- Make sure you're logged in
- Click "Watch Price" on a product
- Wait 1-2 seconds for confirmation

### "Watchlist is empty after refresh"
- Check MongoDB connection: MONGODB_URI in .env
- Check user is logged in correctly
- Check browser console for errors

### "Not receiving emails"
- Verify BREVO_API_KEY in .env
- Check spam/promotions folder
- Wait for next 4-hour monitoring cycle
- Price must drop ≥5% to trigger email

### "Server logs show no [PRICE MONITOR]"
- Server may still be starting up
- Restart the server: `node script.js`
- Check that MongoDB is connected

---

## 🎯 Next Steps

1. **Get API Keys** (2 minutes)
   - MongoDB Atlas account
   - Brevo account
   - ScraperAPI account

2. **Configure .env** (1 minute)
   - Add the 4 API keys

3. **Start Server** (1 minute)
   - Run `node script.js`

4. **Test Feature** (2 minutes)
   - Search product
   - Click Watch Price
   - Open watchlist dashboard

5. **Wait for Price Check** (4 hours)
   - System automatically checks every 4 hours
   - Or restart server to trigger initial check

6. **Get Email Alert!** 🎉
   - Receive email when price drops 5%+

---

**Implementation Ready:** ✅ April 16, 2026  
**Feature Status:** Production Ready  
**Documentation:** Complete

Good luck with your price tracking system! 🚀

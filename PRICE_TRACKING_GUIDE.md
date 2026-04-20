# Price Drop Alert System - Documentation

## Overview

The **Price Watchlist & Drop Alert System** enables users to:
- ✅ Monitor product prices from Amazon, Flipkart, and Google Shopping
- ✅ Receive email notifications when prices drop by 5% or more
- ✅ Track price history over time
- ✅ View savings and price trends

---

## Features

### 1. **Add Products to Watchlist**
- Users can watch any product from search results
- Tracks initial price as baseline
- System automatically stores product details

### 2. **Automatic Price Monitoring**
- **Interval**: Every 4 hours
- **Scope**: Re-scrapes all watched products
- **Detection**: Identifies price changes automatically
- **Comparison**: Baseline price vs. current price

### 3. **Price Drop Detection**
- **Threshold**: 5% price reduction triggers alert
- **Smart Throttling**: User gets max 1 email per 24 hours per product
- **Historical Tracking**: Maintains price history for analysis

### 4. **Email Notifications**
- **Template**: Professional HTML design
- **Content**: 
  - Product details and image
  - Previous price and current price
  - Savings amount and percentage
  - Link back to watchlist
- **Sender**: Cognitive Cart Team
- **Delivery**: Via Brevo API

### 5. **Watchlist Dashboard**
- View all watched products
- See price history (last 5 snapshots)
- Track total savings
- Count of price drops detected
- Remove products from watchlist

---

## API Endpoints

### Add Product to Watchlist
```
POST /api/watchlist/add
Body: {
  "username": "user@email.com",
  "product": {
    "title": "Product Name",
    "price": "25000",
    "image": "https://...",
    "rating": "4.5",
    "store": "Amazon"
  }
}
Response: {
  "message": "Product added to watchlist",
  "watchlistId": "...mongodb_id..."
}
```

### Get User's Watchlist
```
GET /api/watchlist/:username
Response: [
  {
    "_id": "...mongodb_id...",
    "product": { "title": "...", "image": "...", "rating": "..." },
    "currentPrice": 25000,
    "previousPrice": 26000,
    "priceHistory": [
      { "price": 26000, "timestamp": "...", "source": "Amazon" },
      { "price": 25500, "timestamp": "...", "source": "Amazon" },
      { "price": 25000, "timestamp": "...", "source": "Amazon" }
    ],
    "addedAt": "2026-04-16T10:30:00Z",
    "lastChecked": "2026-04-16T14:30:00Z",
    "priceDrops": [
      {
        "dropAmount": 1000,
        "dropPercentage": "3.85",
        "timestamp": "2026-04-16T14:30:00Z"
      }
    ]
  }
]
```

### Remove from Watchlist
```
DELETE /api/watchlist/:watchlistId
Response: {
  "message": "Product removed from watchlist"
}
```

---

## Database Schema

### Collection: `watchlist`

```javascript
{
  _id: ObjectId,
  username: "user@email.com",
  productId: "Lenovo Yoga Slim 7_1713259200000",
  product: {
    title: "Lenovo Yoga Slim 7...",
    image: "https://...",
    rating: "4.5"
  },
  priceHistory: [
    {
      price: 109990,
      timestamp: ISODate("2026-04-16T10:30:00Z"),
      source: "Amazon"
    },
    {
      price: 108500,
      timestamp: ISODate("2026-04-16T14:30:00Z"),
      source: "Amazon"
    }
  ],
  isActive: true,
  addedAt: ISODate("2026-04-16T10:30:00Z"),
  lastChecked: ISODate("2026-04-16T14:30:00Z"),
  priceDropNotifications: [
    {
      dropAmount: 1490,
      dropPercentage: "1.35",
      timestamp: ISODate("2026-04-16T14:32:00Z")
    }
  ]
}
```

---

## Background Job - Price Monitoring

### How It Works

1. **Triggered Every 4 Hours** (configurable in `api/index.js`)
   ```javascript
   setInterval(monitorPricesScheduled, 4 * 60 * 60 * 1000);
   ```

2. **For Each Watched Product:**
   - Re-scrapes product from Amazon, Flipkart, Google Shopping
   - Gets current price from multiple stores
   - Compares with price history
   - Detects drops (>= 5%)

3. **If Price Dropped:**
   - Checks if user was notified in last 24 hours
   - If not, sends email notification
   - Logs notification in `priceDropNotifications`
   - Updates `priceHistory`

4. **Updates Database:**
   ```javascript
   db.collection("watchlist").updateOne(
     { _id: watchlistEntry._id },
     {
       $set: {
         priceHistory: updatedHistory,
         lastChecked: new Date(),
         $push: { priceDropNotifications: {...} }
       }
     }
   );
   ```

---

## Email Notification Example

When a price drop is detected:

**Subject:** 🎉 Price Drop Alert: 5% OFF on "Lenovo Yoga Slim 7..."

**Content:**
```
🎉 Price Drop Alert!

Great news! A product in your watchlist has dropped in price.

PRODUCT: Lenovo Yoga Slim 7 (Smartchoice) Aura Edition...
RATING: ⭐ 4.5

Previous: ₹109,990
New:      ₹104,490

SAVE ₹5,500 (5% OFF)

[View Watchlist Button]

Sent: Cognitive Cart Price Tracking System
```

---

## Frontend Integration (watchlist.html)

### Features Implemented:

1. **Statistics Dashboard**
   - Total products watching
   - Number of price drops detected
   - Total savings accumulated

2. **Watchlist Cards** Display for each product:
   - Product image and title
   - Current and previous prices
   - Price drop badge with savings
   - Price history (last 5 snapshots)
   - Remove button

3. **User Authentication**
   - Check `localStorage.username`
   - Redirect to login if not authenticated

4. **Auto-refresh**
   - Reloads watchlist every 10 minutes
   - Users see latest updates

---

## Configuration

### Environment Variables Required

```env
# MongoDB
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/cognitive_cart

# Email (Brevo)
BREVO_API_KEY=your_brevo_api_key

# Scraping APIs (Optional)
SCRAPER_API_KEY=your_scraper_api_key
SERPAPI_KEY=your_serpapi_key
GROQ_API_KEY=your_groq_api_key
```

### Adjust Monitoring Frequency

Edit `api/index.js` line ~790:
```javascript
// Change from 4 hours to your preferred interval (in milliseconds)
setInterval(monitorPricesScheduled, 2 * 60 * 60 * 1000); // 2 hours
```

### Adjust Price Drop Threshold

Edit `api/index.js` line ~715:
```javascript
// Change from 5% to your preferred threshold
if (priceDropPercentage >= 5) { // Change 5 to desired percentage
```

---

## Usage Flow

### For Users:

1. **Search for Products**
   - Use the search feature to find products

2. **Add to Watchlist**
   - Click "Watch" button on product card
   - Confirms: "Product added to watchlist"

3. **Monitor on Dashboard**
   - Visit `/watchlist.html`
   - View all watched products
   - See price trends and savings

4. **Get Email Alerts**
   - Receive when price drops 5%
   - Click link in email to view watchlist
   - Email sent max once per 24 hours per product

5. **Remove Products**
   - Click "Remove" button when no longer interested
   - Product removed from monitoring

---

## Troubleshooting

### Issue: Not receiving emails?
- ✅ Check BREVO_API_KEY in environment variables
- ✅ Verify email address is correct in user profile
- ✅ Check server logs for email send errors
- ✅ Ensure price drop is >= 5%

### Issue: Watchlist not updating?
- ✅ Wait until next 4-hour cycle (or check logs)
- ✅ Verify MongoDB connection
- ✅ Manual trigger: Restart server to run initial check

### Issue: Price not fetching?
- ✅ Check scraper API keys (SCRAPER_API_KEY, SERPAPI_KEY)
- ✅ At least one scraper must be configured
- ✅ Check API rate limits

### Issue: Duplicate notifications?
- ✅ System prevents within 24 hours
- ✅ Check `priceDropNotifications` array in database

---

## Performance Considerations

- **Database Indexes**: Consider indexing `watchlist` collection:
  ```javascript
  db.collection("watchlist").createIndex({ username: 1, isActive: 1 });
  db.collection("watchlist").createIndex({ lastChecked: 1 });
  ```

- **Scraping Load**: 4-hour interval prevents API rate limiting
  - Monitor Brevo credits
  - Monitor ScraperAPI/SerpAPI quota

- **Email Queue**: Currently synchronous
  - Can be converted to async job queue for scale

---

## Future Enhancements

- [ ] Custom price drop thresholds per user
- [ ] Price prediction (AI-powered recommendations)
- [ ] Multiple watchlist folders/categories
- [ ] Browser push notifications
- [ ] SMS alerts integration
- [ ] Price history graphs/charts
- [ ] Scheduled email digests instead of individual alerts
- [ ] Community compare (vs. other users' prices)
- [ ] Price history exports (CSV)

---

## Support & Contact

For issues or suggestions:
- Check server logs: `console.error` in `api/index.js`
- Monitor MongoDB Atlas dashboard
- Verify Brevo email quota

---

**Last Updated:** April 16, 2026  
**System:** Cognitive Cart v1.0

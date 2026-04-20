#!/bin/bash
# Quick Setup Guide for Price Tracking Feature

echo "🚀 Price Drop Alert System Setup"
echo "================================="
echo ""

# Check if MongoDB URI is set
if [ -z "$MONGODB_URI" ]; then
    echo "⚠️  MONGODB_URI not found in environment variables"
    echo "   Add this to your .env file:"
    echo "   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/cognitive_cart"
fi

# Check if Brevo API Key is set
if [ -z "$BREVO_API_KEY" ]; then
    echo "⚠️  BREVO_API_KEY not found in environment variables"
    echo "   Sign up at https://app.brevo.com/"
    echo "   Add this to your .env file:"
    echo "   BREVO_API_KEY=your_api_key_here"
fi

echo ""
echo "✅ Required Collections:"
echo "   - users"
echo "   - watchlist (auto-created on first add)"
echo ""

echo "📝 Next Steps:"
echo "   1. Start your Node.js server: node script.js"
echo "   2. Open http://localhost:3000 in browser"
echo "   3. Search for a product"
echo "   4. Click '📊 Watch Price' button"
echo "   5. Visit http://localhost:3000/watchlist.html to view watchlist"
echo ""

echo "🔔 Price Monitoring:"
echo "   - Automatic check every 4 hours"
echo "   - Email notification when price drops ≥ 5%"
echo "   - Max 1 email per 24 hours per product"
echo ""

echo "💾 Database Schema:"
echo "   Collection: watchlist"
echo "   - username (string)"
echo "   - product (object with title, image, rating)"
echo "   - priceHistory (array of price snapshots)"
echo "   - isActive (boolean)"
echo "   - priceDropNotifications (array of alerts)"
echo ""

echo "🔧 Configuration:"
echo "   Edit api/index.js to customize:"
echo "   - Line 790: Monitoring interval (default: 4 hours)"
echo "   - Line 715: Price drop threshold (default: 5%)"
echo "   - Line 726: Notification cooldown (default: 24 hours)"
echo ""

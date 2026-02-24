#!/bin/bash

# Test traffic distribution between stable and canary versions
# Usage: ./test-traffic.sh <hostname> <num-requests>

HOSTNAME=${1:-"canary.example.com"}
NUM_REQUESTS=${2:-20}

echo "🧪 Testing traffic distribution for: $HOSTNAME"
echo "📊 Sending $NUM_REQUESTS requests..."
echo ""

for i in $(seq 1 $NUM_REQUESTS); do
  curl -sk https://$HOSTNAME/ | grep -o "v[0-9]\.[0-9]\.[0-9]"
done | sort | uniq -c

echo ""
echo "✅ Test completed!"

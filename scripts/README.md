# Helper Scripts

Automation scripts for setup and testing.

## setup.sh

Interactive setup script that configures the project for your environment.

**Usage:**
```bash
./setup.sh
```

**What it does:**
- Prompts for GitHub username and repository name
- Prompts for domain name
- Updates all ArgoCD configurations
- Updates Gateway HTTPRoute configuration

## test-traffic.sh

Tests traffic distribution between stable and canary versions.

**Usage:**
```bash
./test-traffic.sh <hostname> <num-requests>
```

**Examples:**
```bash
# Test with 20 requests (default)
./test-traffic.sh canary.example.com

# Test with 50 requests
./test-traffic.sh canary.example.com 50
```

**Output:**
```
🧪 Testing traffic distribution for: canary.example.com
📊 Sending 20 requests...

  12 v1.0.0
   8 v2.0.1

✅ Test completed!
```

## Making Scripts Executable

If scripts are not executable:
```bash
chmod +x setup.sh test-traffic.sh
```

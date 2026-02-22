#!/bin/bash

# ────────────────────────────────────────────────
# CONFIG - Update these as needed
AMI_ID="ami-0b6c6ebed2801a5cb"                  # Amazon Linux 2 (us-east-1)
INSTANCE_TYPE="t2.micro"
KEY_NAME="Key_Pair_Ghaffar"                          # Your key pair name
SECURITY_GROUP_ID="sg-0072838f36f431ffa"        # FIXED: Use ID with --security-group-ids
INSTANCE_NAME="TEC2WithS3Access2"
REGION="us-east-1"                              # Explicit region is safer

# Optional: If you want a specific subnet (public/private)
# SUBNET_ID="--subnet-id subnet-xxxxxxxxxxxxxxxxx"

echo "Launching EC2 instance: $INSTANCE_NAME ..."

# Launch command - note space before EVERY backslash
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
  --query "Instances[0].InstanceId" \
  --output text \
  --region "$REGION" 2>&1)

# Check if launch succeeded (INSTANCE_ID should start with 'i-')
if [[ "$INSTANCE_ID" =~ ^i- ]]; then
  echo "✅ EC2 Instance Launched: $INSTANCE_NAME with ID $INSTANCE_ID"
  
  echo "Waiting for instance to be running (may take 30-90 seconds)..."
  aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --region "$REGION"
  echo "Instance is now running! You can SSH or check console."
else
  echo "❌ Launch FAILED!"
  echo "Error details:"
  echo "$INSTANCE_ID"   # This captures the actual AWS error
  echo ""
  echo "Quick fixes to try:"
  echo "1. Check security group: aws ec2 describe-security-groups --group-ids $SECURITY_GROUP_ID --region $REGION"
  echo "2. Check AMI/key: Ensure they exist in $REGION"
  echo "3. Run with --debug for more info"
  exit 1
fi
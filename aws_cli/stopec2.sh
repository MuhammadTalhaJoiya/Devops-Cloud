#!/bin/bash

INSTANCE_ID="i-0c92a4f32a732e8af"  # Replace with actual instance ID

aws ec2 stop-instances --instance-ids $INSTANCE_ID
echo "🛑 EC2 instance stopped."

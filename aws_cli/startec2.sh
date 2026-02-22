#!/bin/bash

INSTANCE_ID="i-0c92a4f32a732e8af"

aws ec2 start-instances --instance-ids $INSTANCE_ID
echo "▶️ EC2 instance started."

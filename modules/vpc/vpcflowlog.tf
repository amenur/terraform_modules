
resource "aws_flow_log" "vpc_flow_log" {
    count = var.enable_vpc_flow_log ? 1 : 0

    iam_role_arn = aws_iam_role.vpc_flow_log_role[count.index].arn
    log_destination = aws_cloudwatch_log_group.vpc_flow_log[count.index].arn
    traffic_type = "ALL"
    vpc_id = aws_vpc.this.id

    depends_on = [
      aws_vpc.this
    ]
  
}

 resource "aws_kms_key" "cloudwatch_key" {
     count = var.enable_kms_key_vpc_flow_log ? 1 : 0

     description = "KMS key for encrypt vpc flow logs in CloudWatch"
     deletion_window_in_days = 30
     enable_key_rotation = true
  
 }

 resource "aws_kms_alias" "cloudwatch_key_alias" {
     count = var.enable_kms_key_vpc_flow_log ? 1 : 0

     name = var.kms_key_alias
     target_key_id = aws_kms_key.cloudwatch_key[count.index].id
  
 }

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
    count = var.enable_vpc_flow_log ? 1 : 0

    name = "vpc_flow_log"
    //kms_key_id = aws_kms_key.cloudwatch_key.id
    retention_in_days = 1

}

resource "aws_iam_role" "vpc_flow_log_role" {
  count = var.enable_vpc_flow_log ? 1 : 0

  name               = "vpc_flow_log_role"
  assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "vpc-flow-logs.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
        
    ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
    count = var.enable_vpc_flow_log ? 1 : 0
    
    name = "vpc_flow_log_policy"
    role = aws_iam_role.vpc_flow_log_role[count.index].id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
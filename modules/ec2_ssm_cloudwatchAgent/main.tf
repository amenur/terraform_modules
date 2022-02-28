
# -------------------------------------------------------------------------------------
# KEY PAIR
# -------------------------------------------------------------------------------------

resource "tls_private_key" "private_key" {
  algorithm = var.private_key_algorithm
  rsa_bits  = var.rsa_bits
}


resource "aws_key_pair" "key_pair" {
  key_name = var.enable_self_ami ? "${local.name_self_ami}-key" : "${local.name_new_ami}-key"
  #public_key = file(var.ssh_key_path)
  public_key = tls_private_key.private_key.public_key_pem
}

# -------------------------------------------------------------------------------------
# Store keys in 'SSM PARAMETER STORE' AND/OR LOCAL
# -------------------------------------------------------------------------------------

resource "aws_ssm_parameter" "private_key_ssm_param_store" {
  count = var.enable_ssh_key_ssm_param_store ? 1 : 0

  name        = var.enable_self_ami ? "/${local.name_self_ami}/private_key" : "/${local.name_new_ami}/private_key"
  description = "Private Key"
  type        = "SecureString"
  value       = tls_private_key.private_key.private_key_pem
}

resource "aws_ssm_parameter" "public_key_ssm_parameter_store" {
  count = var.enable_ssh_key_ssm_param_store ? 1 : 0

  name        = var.enable_self_ami ? "/${local.name_self_ami}/public_key" : "/${local.name_new_ami}/public_key"
  description = "Public Key"
  type        = "SecureString"
  value       = tls_private_key.private_key.public_key_pem
}

resource "aws_ssm_parameter" "public_key_openssh_ssm_parameter" {
  count = var.enable_ssh_key_ssm_param_store ? 1 : 0

  name        = var.enable_self_ami ? "/${local.name_self_ami}/public-key-openssh" : "/${local.name_new_ami}/public-key-openssh"
  description = "Public Key in OpenSSH format"
  type        = "SecureString"
  value       = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "ssh_key" {
  count = var.enable_ssh_key_pem_local || (var.enable_ssh_key_pem_local == false && var.enable_ssh_key_ssm_param_store == false) ? 1 : 0

  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.private_key.private_key_pem
  file_permission = "0400"
}

# -----------------------------------------------------------------
# Security Groups
# -----------------------------------------------------------------

data "aws_security_group" "public_sg" {
  count = var.enable_private_sg && var.enable_public_sg == false ? 1 : 0

  filter {
    name   = "group-id"
    values = [local.public_sg]
  }

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

data "aws_security_group" "private_sg" {
  count = var.enable_private_sg && var.enable_public_sg == false ? 1 : 0

  filter {
    name   = "group-id"
    values = [local.private_sg_app]
  }

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}


# -----------------------------------------------------------------
# IAM Resources
# -----------------------------------------------------------------

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
    sid    = ""
  }
}


resource "aws_iam_role" "ec2_role" {
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  name               = "EC2RoleForSSMandCloudWatchLogs"
  managed_policy_arns = [
    var.amazon_ec2_role_for_ssm_policy_arn,
    var.cloudwatch_agent_server_policy_policy_arn,
    var.amazon_ssm_full_access_policy_arn
  ]
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  path = "/"
  role = aws_iam_role.ec2_role.name
}


# -----------------------------------------------------------------
# AMI
# -----------------------------------------------------------------


data "aws_ami" "new_ami" {
  count = var.enable_new_ami ? 1 : 0

  most_recent = var.most_recent
  owners      = [var.owner]

  filter {
    name   = "name"
    values = [var.new_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.new_ami_virtualization_type]
  }

  filter {
    name   = "root-device-type"
    values = [var.new_ami_root_device_type]
  }
  #AMZN Linux 2
}


data "aws_ami" "self_ami" {
  count = var.enable_self_ami ? 1 : 0

  most_recent = var.most_recent
  owners      = ["self"]

  filter {
    name = "name"
    #    values = ["amzn2-ami-hvm-2.*-x86_64-gp2"]
    values = [var.self_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.self_ami_virtualization_type]
  }
  #AMZN Linux 2
}


# ----------------------------------------------------------------
# Network
# ----------------------------------------------------------------

resource "aws_eip" "eip" {
  count    = length(aws_instance.this)
  instance = aws_instance.this[count.index].id
  vpc      = true
  tags = merge(
    var.project_tags,
    {
      Name = "${var.project_tags.Project_Name}-eip"
    },
  )
}


# ----------------------------------------------------
# Instance
# ----------------------------------------------------


resource "aws_instance" "this" {
  count = var.enable_new_instance ? 1 : 0

  # If "self" AMI is DISABLE and "new" AMI is enable --> TRUE --> SELF AMI
  # If "self" AMI is DISABLE and "new" AMI is DISABLE --> TRUE --> SELF AMI
  # If "self" AMI is ENABLE and "new" AMI is ENABLE --> TRUE --> SELF AMI
  # IF "self" AMI is DISABLE and "new" AMI is ENABLE --> FALSE --> NEW AMI
  #  ami           = (var.enable_self_ami > 0 && var.enable_new_ami < 1) || (var.enable_self_ami < 1 && var.enable_new_ami < 1) || (var.enable_self_ami > 0 && var.enable_new_ami > 0) ? data.aws_ami.self_ami.id : data.aws_ami.new_ami.id
  ami                     = (var.enable_self_ami == false && var.enable_new_ami == true) ? data.aws_ami.new_ami[count.index].id : data.aws_ami.self_ami[count.index].id
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.ec2_instance_profile.name
  key_name                = aws_key_pair.key_pair.key_name
  availability_zone       = var.availability_zone
  subnet_id               = var.subnet_id
  monitoring              = var.enable_ec2_monitoring
  disable_api_termination = var.enable_instance_termination_protection

  metadata_options {
    http_tokens = "required"
  }
  vpc_security_group_ids = [
    var.security_groups
  ]

  root_block_device {
    encrypted = true
  }

  tags = merge(
    var.project_tags,
    {
      Name = "${var.project_tags.Project_Name}-"
    }
  )

  lifecycle {
    ignore_changes = [ami]
  }
}


resource "aws_ebs_volume" "data" {
  count = var.enable_ebs_volume ? 1 : 0

  availability_zone = var.availability_zone
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type
  encrypted         = var.ebs_volume_encrypted

  kms_key_id = var.enable_kms_ebs_encryption_key ? aws_kms_key.ebs_encryption[0].arn : null

  tags = merge(
    var.project_tags,
    {
      Name = "${var.project_tags.Project_Name}-EBS-data"
    }
  )
}

resource "aws_kms_key" "ebs_encryption" {
  count = var.enable_kms_ebs_encryption_key ? 1 : 0

  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_volume_attachment" "attach_ebs_web" {
  count = length(aws_instance.this)

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.data[count.index].id
  instance_id = aws_instance.this[count.index].id
}
  
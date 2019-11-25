# Creating a db subnet gp; meaning a subnet grouph to host our DB
# resource "aws_db_subnet_group" "default" {
#   name        = "main_subnet_group"
#   description = "Our main group of subnets"
#   subnet_ids  = ["${aws_subnet.private_subnet.id}", "${aws_subnet.private_subnet2.id}"]
# }


# resource "aws_db_instance" "default" {
#   allocated_storage         = 20
#   engine                    = "mysql"
#   engine_version            = "5.7"
#   instance_class            = "db.t2.micro"
#   name                      = "mydb"
#   username                  = "sujay"
#   password                  = "sujay123"
#   parameter_group_name      = "default.mysql5.7"
#   publicly_accessible       = "true"
#   identifier                = "dbinstance1"
#   multi_az                  = "false"
#   db_subnet_group_name      = "${aws_db_subnet_group.default.name}"
#   final_snapshot_identifier = "dbinstance1-final-snapshot"
#   vpc_security_group_ids = ["${aws_security_group.db_sec.id}"]
#   skip_final_snapshot       = "true"

# }

resource "aws_iam_policy" "policy1" {
  name        = "CodeDeploy-EC2-S3"
  description = "EC2 s3 access policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Put*",
                "s3:Delete*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy2" {
  name        = "TravisCI-Upload-To-S3"
  description = "s3 upload Policy for user TravisCI"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy3" {
  name        = "TravisCI-Code-Deploy"
  description = "Code Deploy Policy for user TravisCI"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "user" {
  name = "TravisCI-user"
}

resource "aws_iam_user_policy_attachment" "attach2" {
  user       = "${aws_iam_user.user.name}"
  policy_arn = "${aws_iam_policy.policy2.arn}"
  
  
}
resource "aws_iam_user_policy_attachment" "attach3" {
  user       = "${aws_iam_user.user.name}"
  policy_arn =  "${aws_iam_policy.policy3.arn}"
}

resource "aws_iam_role" "role1" {
  name = "CodeDeployEC2ServiceRole"
  description = "Allows EC2 instances to call AWS services on your behalf"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role1-attact1" {
  role       = "${aws_iam_role.role1.name}"
  policy_arn = "${aws_iam_policy.policy1.arn}"
}

resource "aws_iam_instance_profile" "role1_profile" {
  name = "CodeDeployEC2ServiceRole"
  role = "${aws_iam_role.role1.name}"
}



resource "aws_iam_role" "role2" {
  name = "CodeDeployServiceRole"
  description = "Allows CodeDeploy to call AWS services such as Auto Scaling on your behalf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy_service" {
  role       = "${aws_iam_role.role2.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}



resource "aws_instance" "mongoDB" {
  ami = "${var.my_ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.db_sec.id}"]
  tags = {
      name = "My DB"
  }
  iam_instance_profile="${aws_iam_instance_profile.role1_profile.name}"

}


resource "aws_instance" "default" {
    ami = "${var.my_ami}"
    key_name = "${var.my_key}"
    instance_type = "t2.micro"
    user_data         = <<EOF
                        #! /bin/bash
                        echo host="${aws_instance.mongoDB.private_ip}" >> .env
    EOF

    vpc_security_group_ids = ["${aws_security_group.web_sec.id}"]
    associate_public_ip_address = true
    source_dest_check           = false
    subnet_id = "${aws_subnet.public_subnet.id}"

    depends_on = ["aws_instance.mongoDB"]

#   Need to attach role to this for codeDeploy to work

    tags = {
        name = "Web instance"
    }
    iam_instance_profile="${aws_iam_instance_profile.role1_profile.name}"
}

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

resource "aws_instance" "mongoDB" {
  ami = "${var.my_ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.db_sec.id}"]
  tags = {
      name = "My DB"
  }

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
}

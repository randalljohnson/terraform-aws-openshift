//  Create the bastion userdata script.
data "template_file" "setup-bastion" {
  template = "${file("${path.module}/files/setup-bastion.sh")}"
  vars {
    availability_zone = "${lookup(var.subnetaz, var.region)}"
  }
}

//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_instance" "bastion" {
  ami                  = "${data.aws_ami.rhel7_2.id}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.bastion-instance-profile.id}"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  user_data            = "${data.template_file.setup-bastion.rendered}"

  security_groups = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-ssh.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name    = "OpenShift Bastion"
    Project = "openshift"
  }
}

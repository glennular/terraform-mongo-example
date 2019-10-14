output "mongodb_instance_id_list" { value = "${aws_instance.mongo_db_ins.*.id}" }
output "mongo_db_sg_id" { value = "${aws_security_group.app_sg.id}" }
output "mongo_private_ip_list" { value = "${aws_instance.mongo_db_ins.*.private_ip}" }
output "mongo_public_ip_list" { value = "${aws_instance.mongo_db_ins.*.public_ip}" }
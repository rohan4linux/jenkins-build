resource "aws_ecr_repository" "hello-world" {
  name = "hello-world"
}

output "hello-world-repo" {
  value = "${aws_ecr_repository.hello-world.repository_url}"
}

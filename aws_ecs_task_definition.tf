data "template_file" "hello-world" {
   template = "${file("templates/ecs/hello-world.json.tpl")}"
   vars = {
     REPOSITORY_URL = "${aws_ecr_repository.hello-world.repository_url}"
     AWS_ECR_REGION = "${var.AWS_ECR_REGION}"
   }
 }

resource "aws_ecs_task_definition" "hello_world" {
  family                   = "hello-world-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::036281399343:role/ecsTaskExecutionRole"
  container_definitions    = "${data.template_file.hello-world.rendered}"
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.hello_world_task.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hello_world.id
    container_name   = "hello-world-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.hello_world]
}

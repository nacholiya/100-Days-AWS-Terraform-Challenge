resource "local_file" "local" {
  filename = "day-39-file_create_before_destroy.txt"
  content  = "Hello! From Day 39 testing create before destroy"
  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "local_1" {
  filename = "day-39-file_prevent_destroy.txt"
  content  = "Hello! From Day 39"
  lifecycle {
    prevent_destroy = false
  }
}

resource "local_file" "local_2" {
  filename = "day-39-file_ignore_changes"
  content  = "Hello! From Ignore Changes Day 39"
  lifecycle {
    ignore_changes = [content]
  }
}
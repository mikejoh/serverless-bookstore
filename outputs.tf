output "books_rest_api_endpoint" {
  value = "${aws_api_gateway_deployment.books_rest_api_deployment.invoke_url}/books"
}
resource "aws_api_gateway_rest_api" "books_rest_api" {
    name        = "bookstore"
}

resource "aws_api_gateway_resource" "books_rest_api_resource" {
    rest_api_id = "${aws_api_gateway_rest_api.books_rest_api.id}"
    parent_id   = "${aws_api_gateway_rest_api.books_rest_api.root_resource_id}"
    path_part   = "books"
}

resource "aws_api_gateway_method" "books_rest_api_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.books_rest_api.id}"
    resource_id   = "${aws_api_gateway_resource.books_rest_api_resource.id}"
    http_method   = "ANY"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "books_rest_api_integration" {
    rest_api_id               = "${aws_api_gateway_rest_api.books_rest_api.id}"
    resource_id               = "${aws_api_gateway_resource.books_rest_api_resource.id}"
    http_method               = "${aws_api_gateway_method.books_rest_api_method.http_method}"
    type                      = "AWS_PROXY"
    integration_http_method   = "POST"
    uri                       = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.books_function.arn}/invocations"
}

resource "aws_lambda_permission" "books_rest_api_integration" {
    statement_id  = "AllowBooksInvoke"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.books_function.function_name}"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_api_gateway_rest_api.books_rest_api.execution_arn}/*/*/books"
}


resource "aws_api_gateway_deployment" "books_rest_api_deployment" {
    depends_on = [
        "aws_api_gateway_integration.books_rest_api_integration"
    ]
    rest_api_id = "${aws_api_gateway_rest_api.books_rest_api.id}"
    stage_name  = "staging"
}
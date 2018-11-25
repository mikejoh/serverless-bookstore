resource "aws_lambda_function" "books_function" {
  filename         = "./books/main.zip"
  function_name    = "books"
  role             = "${aws_iam_role.lambda_books_executor.arn}"
  handler          = "main"
  source_code_hash = "${base64sha256(file("./books/main.zip"))}"
  runtime          = "go1.x"
}
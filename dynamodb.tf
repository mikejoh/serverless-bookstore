resource "aws_dynamodb_table" "books_table" {
    name           = "Books"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "ISBN"

    attribute {
        name = "ISBN"
        type = "S"
    }
}
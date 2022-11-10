output "firehose_arn" {
  value = aws_kinesis_firehose_delivery_stream.forehose_delivery_stream.arn
}
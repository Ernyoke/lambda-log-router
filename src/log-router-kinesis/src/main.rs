use aws_config::meta::region::RegionProviderChain;
use aws_sdk_firehose::error::PutRecordError;
use aws_sdk_firehose::model::Record;
use aws_sdk_firehose::output::PutRecordOutput;
use aws_sdk_firehose::types::{Blob, SdkError};
use aws_sdk_firehose::Client;
use lambda_extension::{service_fn, Error, Extension, LambdaLog, LambdaLogRecord, SharedService};
use lazy_static::lazy_static;
use std::env;

static ENV_STREAM_NAME: &str = "KINESIS_DELIVERY_STREAM";

// Read the stream name from an environment variable
lazy_static! {
    static ref STREAM: String = env::var(ENV_STREAM_NAME).unwrap_or_else(|e| panic!(
        "Could not read environment variable {}! Reason: {}",
        ENV_STREAM_NAME, e
    ));
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    println!("Loading extension...");
    // Register the handler to our extension
    let logs_processor = SharedService::new(service_fn(handler));

    Extension::new()
        .with_logs_processor(logs_processor)
        .run()
        .await?;

    Ok(())
}

async fn handler(logs: Vec<LambdaLog>) -> Result<(), Error> {
    // Build the Kinesis Firehose client
    let firehose_client = build_firehose_client().await;
    // Listen to all the events emitted when a Lambda Function is logging something. Send these
    // events to a Firehose delivery stream
    for log in logs {
        match log.record {
            LambdaLogRecord::Function(record) | LambdaLogRecord::Extension(record) => {
                put_record(&firehose_client, STREAM.as_str(), &record).await?;
            }
            _ => (),
        }
    }
    Ok(())
}

// Build the Firehose client
async fn build_firehose_client() -> Client {
    let region_provider = RegionProviderChain::default_provider();
    let shared_config = aws_config::from_env().region(region_provider).load().await;
    let client = Client::new(&shared_config);
    client
}

// Send a message to the Firehose stream
async fn put_record(
    client: &Client,
    stream: &str,
    data: &str,
) -> Result<PutRecordOutput, SdkError<PutRecordError>> {
    let blob = Blob::new(data);

    client
        .put_record()
        .record(Record::builder().data(blob).build())
        .delivery_stream_name(stream)
        .send()
        .await
}

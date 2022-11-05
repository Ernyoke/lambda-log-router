use lambda_extension::{Error, Extension, LambdaLog, LambdaLogRecord, service_fn, SharedService};

async fn handler(logs: Vec<LambdaLog>) -> Result<(), Error> {
    for log in logs {
        println!("LambdaLog: {:?}", log);
        match log.record {
            LambdaLogRecord::Function(_record) => {
                println!("Function: {:?}", _record);
            }
            LambdaLogRecord::Extension(_record) => {
                println!("Extension: {:?}", _record);
            }
            _ => (),
        }
    }
    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    println!("Loading extension...");
    let logs_processor = SharedService::new(service_fn(handler));

    Extension::new().with_logs_processor(logs_processor).run().await?;

    Ok(())
}



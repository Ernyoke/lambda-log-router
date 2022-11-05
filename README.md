# lambda-log-router

## Building

### Requirements

- Rust: [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)
- cargo-lambda: [https://www.cargo-lambda.info/guide/installation.html](https://www.cargo-lambda.info/guide/installation.html)
- terragrunt
- terraform (>1.0.0)

### Steps to build

1. Build the Lambda extension:

```bash
cargo lambda build --extension
```

2. Deploy the infrastructure:

```bash
cd live/lamdba
terragrunt run-all apply
```
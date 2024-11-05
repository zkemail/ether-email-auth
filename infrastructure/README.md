
# Infrastructure Management Scripts

This document provides instructions on how to use the provided scripts to apply metrics and alerts to your Google Cloud Platform (GCP) environment.

## Prerequisites

- Ensure you have the [Google Cloud SDK](https://cloud.google.com/sdk) installed and authenticated.
- Make sure `jq` is installed for JSON processing.

## Applying Metrics

To apply a specific metric from a JSON file, use the `apply_metric.sh` script. This script reads the metric configuration from the specified JSON file and applies it to your GCP project.

### Usage

```bash
cd /path/to/your/project/infrastructure/metrics
./apply_metric.sh metric_file.json
```

- Replace `/path/to/your/project` with the root directory of your project.
- Replace `metric_file.json` with the path to the metric JSON file in the metrics directory.

## Applying Alerts

To apply a specific alert policy from a JSON file, use the `apply_alert.sh` script. This script reads the alert policy configuration from the specified JSON file and applies it to your GCP project.

### Usage

```bash
cd /path/to/your/project/infrastructure/alerts
./apply_alert.sh alert_file.json
```

- Replace `/path/to/your/project` with the root directory of your project.
- Replace `alert_file.json` with the path to your alert policy JSON file in the alerts directory.

## Additional Notes

- Ensure that you have the necessary permissions to apply metrics and alerts in your GCP project.
- If you encounter any errors, refer to the script logs for more details.

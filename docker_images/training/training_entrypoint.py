import os
from datetime import datetime

import boto3
import pandas as pd

MODEL_NAME = os.environ['MODEL_NAME']
MODEL_ARTIFACTS_S3_PATH = os.environ['MODEL_ARTIFACTS_S3_PATH']
TRAINING_DATA_PATH = os.environ['TRAINING_DATA_PATH']


class ModelDetails:
    def __init__(
            self,
            model_name: str,
            model_artifact_s3_path: str,
            model_config: dict
    ):
        self.model_name = model_name
        self.initiated_timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.model_artifact_s3_path = model_artifact_s3_path
        self.model_config = model_config


def save_preprocessing_artifacts() -> str:
    pass


def save_trained_model() -> str:
    pass


def train(df: pd.DataFrame) -> dict:
    # pre-processing
    save_preprocessing_artifacts()

    # training
    save_trained_model()
    pass


def run_job():
    """
    Store the model details in DynamoDB.
    :return:
    """
    df = pd.read_csv(TRAINING_DATA_PATH)
    train_config = train(df=df)

    body = ModelDetails(
        MODEL_NAME,
        MODEL_ARTIFACTS_S3_PATH,
        train_config
    ).__dict__

    client = boto3.client("dynamodb")

    pass


if __name__ == "__main__":
    try:
        run_job()
    except Exception as e:
        # Call Simple Email Service - Training Failed
        print(e)
        pass
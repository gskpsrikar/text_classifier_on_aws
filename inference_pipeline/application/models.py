import datetime

from typing import Optional
from pydantic import BaseModel


class IncomingData(BaseModel):
    model_name: str
    input_data: str


class InferenceResult(BaseModel):

    __tablename__ = "inference_result"

    model_name: str
    input_data: str
    prediction: str
    annotated: Optional[bool] = False
    annotation_value: Optional[str]
    timestamp: Optional[datetime.datetime] = datetime.datetime.utcnow()


if __name__ == "__main__":
    data = {
        "model_name": "test",
        "model_version": "test",
        "prediction": "test",
        "predicted_value": "test",
        "annotation_value": "test"
    }
    x = InferenceResult(**data)
    x.predicted_value = 85
    print(x.dict())

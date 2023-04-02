from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class InferenceResult(Base):

    __tablename__ = "inference_result"

    model_name = Column(String, primary_key=True)
    model_version = Column(String, primary_key=False)
    input_query = Column(String, primary_key=False)
    predicted_value = Column(String)
    annotated = Column(Boolean)
    annotation_value = Column(String)

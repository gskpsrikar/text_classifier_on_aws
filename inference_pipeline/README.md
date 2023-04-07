# Inference Pipeline
Accept user's request for machine learning model inference. Generates a prediction. Save the prediction in a database
besides and responds to the user with the same prediction.

## Hosting
1. Model is loaded when the Flask application is run.
2. The Flask application is containerized with Docker.
3. The Docker container is hosted on Amazon ECS.


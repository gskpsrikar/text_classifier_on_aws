cd inference_pipeline
docker build -t my_flask_app .
docker run -p 5000:5000 my_flask_app
cd ..

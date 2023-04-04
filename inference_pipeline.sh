cd inference_pipeline
docker build -t my_flask_app .
docker run -p 5000:5000 my_flask_app
cd ..

#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 840807221296.dkr.ecr.us-east-1.amazonaws.com
#cd inference_pipeline
#docker build -t text_classifier_inference_image .
#echo "docker build completed"
#docker tag text_classifier_inference_image:latest 840807221296.dkr.ecr.us-east-1.amazonaws.com/text_classifier_inference_image:text_classifier_inference_image
#docker push 840807221296.dkr.ecr.us-east-1.amazonaws.com/text_classifier_inference_image:text_classifier_inference_image
#echo "pushing completed"
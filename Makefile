.PHONY: server
server:
	hugo server

.PHONY: publish
publish:
	hugo
	aws s3 sync uploads/ s3://bennysbanter.com.au/uploads/
	aws s3 sync public/ s3://bennysbanter.com.au
	rm -r public
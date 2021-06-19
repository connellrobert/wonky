meta install
cd complaint
docker build -t complaint .
cd ../department/datasource
docker build -t dep-mysql -f Dockerfile.db .
cd ../
docker build -t department-api -f Dockerfile.app .
cd ../IMS
docker build -t ims-api .
cd ..
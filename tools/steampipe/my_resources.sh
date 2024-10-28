#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

COLOR=${BLUE}


#printf "This is in ${BLUE}blue${NC}\n"
#exit 1
#echo -e "\033[34m This is blue text!\033[0m"

printf "${COLOR}Resources Report (for AWS $PROFILE)${NC}\n"
printf "${COLOR}EC2s${NC}\n"
./steampipe-ec2.sh $PROFILE

printf "${COLOR}Lambda${NC}\n"
./steampipe-lambda.sh $PROFILE

printf "${COLOR}VPC${NC}\n"
./steampipe-vpc.sh $PROFILE

printf "${COLOR}SUBNET${NC}\n"
./steampipe-subnet.sh $PROFILE

#echo ROUTE TABLE RULEs
##./steampipe-route-table.sh
#./steampipe-route-table-rule.sh $PROFILE

printf "${COLOR}ECS${NC}\n"
./steampipe-ecs.sh $PROFILE

printf "${COLOR}EKS${NC}\n"
./steampipe-eks.sh $PROFILE

printf "${COLOR}LBS${NC}\n"
./steampipe-lb.sh $PROFILE

printf "${COLOR}EIP${NC}\n"
./steampipe-eip.sh $PROFILE

printf "${COLOR}NAT GW${NC}\n"
./steampipe-nat-gateway.sh $PROFILE

printf "${COLOR}IGW${NC}\n"
./steampipe-igw.sh $PROFILE

printf "${COLOR}RDS${NC}\n"
./steampipe-rds.sh $PROFILE

printf "${COLOR}SG${NC}\n"
./steampipe-sg.sh $PROFILE

printf "${COLOR}CLOUDFORM${NC}\n"
./steampipe-cloudform.sh
echo

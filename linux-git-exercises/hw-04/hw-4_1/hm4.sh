mkdir -p ./backup/emili/$(date +"%Y/%m/%d")
cp nginx_requests_total.txt ./backup/emili/$(date +"%Y/%m/%d")/nginx_logs_$(date +"%Y%m%d").log

if [ $(date +"%u") -eq 7 ];  
then    
tar -czvf nginx_logs_$(date +"%Y%m%d").tar.gz ./backup/emili/$(date -d "6 days ago" +"%Y/%m/%d")/nginx_logs_$(date -d "6 days ago" '+%Y%m%d').log ./backup/emili/$(date -d "5 days ago" +"%Y/%m/%d")/nginx_logs_$(date -d "5 days ago" '+%Y%m%d').log ./backup/emili/$(date -d "4 days ago" +"%Y/%m/%d")/nginx_logs_$(date -d "4 days ago" '+%Y%m%d').log ./backup/emili/$(date -d "3 days ago" +"%Y/%m/%d")/nginx_logs_$(date -d "3 days ago" '+%Y%m%d').log ./backup/emili/$(date -d "2 days ago" +"%Y/%m/%d")/nginx_logs_$(date -d "2 days ago" '+%Y%m%d').log ./backup/emili/$(date -d "1 days ago" +"%Y/%m/%d")/nginx_logs_$(date -d "1 days ago" '+%Y%m%d').log ./backup/emili/$(date +"%Y/%m/%d")/nginx_logs_$(date +"%Y%m%d").log
fi
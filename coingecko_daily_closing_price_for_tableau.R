library(geckor)
library(dplyr)

target_tokens <- c("binancecoin",
                   "ftx-token",
                   "okb",
                   "huobi-token",
                   "gatechain-token",
                   "kucoin-shares")

#We can check the coin_ids on the website below.
#https://docs.google.com/spreadsheets/d/1wTTuxXt8n9q7C4NDXqQpI3wpKu1_5bGVmP9Xz0XGSyU/edit#gid=0

historical_data_df = data.frame()
columnList = c("timestamp", "price")


for (i in 1:length(target_tokens)) {

  token_data <- coin_history(coin_id = target_tokens[i], vs_currency = "usd",days = "max")
  token_data <- token_data[, columnList]
  token_data <- subset(token_data , as.Date(timestamp) >= as.Date("2020/01/01"))
  
  if (i == 1){
    historical_data_df <- dplyr::bind_rows(historical_data_df, token_data )
    
  }else{
    historical_data_df <- left_join(historical_data_df, token_data, by = "timestamp")
  }
}

#change each columnname of historical_data_df
for_rename <- c("Date", target_tokens)
colnames(historical_data_df)[ 1:length(historical_data_df) ] <- for_rename

write.csv(historical_data_df, file="tokens_historical_data.csv", row.names=FALSE)
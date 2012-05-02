require './requester.rb'
require './excel.rb'

@exc = Excel.new("report.csv")
@exc.create_worksheets(1)
@number_of_headers = 21
@column_names = ["Offer Id", "Offer name", "Affiliate Company", "Advertiser Company", "Datetime", "Status", "Payout", 
                "Revenue", "Sale Amount", "IP address", "Transaction ID", "Source", "Affiliate Sub ID 1", 
                "Affiliate Sub ID 2", "Affiliate Sub ID 3", "Affiliate Sub ID 4", "Affiliate Sub ID 5", 
                "Tracking Link Referrer", "Conversion Pixel Referrer", "Country", "Browser"]
@exc.create_headers(@number_of_headers, @column_names)

URL = {
  :hasoffers => "http://sponsorpaynetwork.api.hasoffers.com/Api/json"
}

response = Requester.make_request(
  URL[:hasoffers],
  {
    "Format"                          => "json",
    "Service"                         => "HasOffers",
    "Version"                         => "2",
    "NetworkId"                       => "****************",
    "NetworkToken"                    => "****************",
    "Target"                          => "Report",
    "Method"                          => "getConversions",
    "fields[]"                        => ["Offer.id", "Offer.name", "Affiliate.company", "Advertiser.company", 
                                         "Stat.datetime", "Stat.status", "Stat.payout", "Stat.revenue", "Stat.sale_amount",
                                         "Stat.ip", "Stat.ad_id", "Stat.source", "Stat.affiliate_info1", 
                                         "Stat.affiliate_info2", "Stat.affiliate_info3", "Stat.affiliate_info4",
                                         "Stat.affiliate_info5", "Stat.refer", "Stat.pixel_refer", "Country.name", 
                                         "Browser.display_name"],
    "filters[Stat.date][conditional]" => "EQUAL_TO",
    "filters[Stat.date][values][]"    => "2012-04-01",
    "limit"                           => "1000",
    "page"                            => "1"
  },
  :get 
)

@page_numbers = response["response"]["data"]["pageCount"]
print "Number of pages: #{@page_numbers}\n"

@content = Array.new

response["response"]["data"]["data"].each do |key|
  @content << ["#{key["Offer"]["id"]}", "#{key["Offer"]["name"]}", "#{key["Affiliate"]["company"]}", 
               "#{key["Advertiser"]["company"]}", "#{key["Stat"]["datetime"]}", "#{key["Stat"]["status"]}",
               "#{key["Stat"]["payout"]}", "#{key["Stat"]["sale_amount"]}", "#{key["Stat"]["revenue"]}", 
               "#{key["Stat"]["ip"]}", "#{key["Stat"]["ad_id"]}", "#{key["Stat"]["source"]}", 
               "#{key["Stat"]["affiliate_info1"]}", "#{key["Stat"]["affiliate_info2"]}", "#{key["Stat"]["affiliate_info3"]}",
               "#{key["Stat"]["affiliate_info4"]}", "#{key["Stat"]["affiliate_info5"]}", "#{key["Stat"]["refer"]}",
                "#{key["Stat"]["pixel_refer"]}", "#{key["Country"]["name"]}", "#{key["Browser"]["display_name"]}"] 
end

@exc.create_excel_content(@content)

@exc.close

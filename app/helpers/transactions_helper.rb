module TransactionsHelper

	def amazonproductfind
	    Amazon::Ecs.configure do |options|
	      options[:AWS_access_key_id] = ENV["AWSAccessKeyId"]
	      options[:AWS_secret_key] = ENV["AWSSecretKey"]
	      options[:associate_tag] = ENV["AMAZON_ASSOCIATE_TAG"]
	    end
	    p "search params #{params[:search]}"
	    res = Amazon::Ecs.item_search(params[:search], :response_group => 'Medium', :search_index => 'All')
	    #@doc = Nokogiri::XML(open("#{res}"))
	    if res
	      p "got a response from AMZN"
	    end

	    if res.has_error?
	      p res.error
	    else
	      @searchresult = []
	      res.items.each do |item|
	        search_item = {}
	        search_item["asin"] = item.get("ASIN")
	        search_item["name"] = item.get('ItemAttributes/Title')
	        search_item["current_price"] = item.get('OfferSummary/LowestNewPrice/FormattedPrice')
	        search_item["upc"]= item.get('ItemAttributes/UPC')
	        search_item["listing_url"]= item.get('Item/DetailPageURL')
	        #search_item["image_url"]= item.get('ImageSets/ImageSet(Category=Primary)/LargeImage/URL')
	        @searchresult.push search_item
	      end
	      render :json => @searchresult 
	      
	    end
	end
end


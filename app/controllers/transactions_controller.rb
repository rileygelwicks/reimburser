class TransactionsController < ApplicationController

  def new
    @user= current_user
    @transaction = Transaction.new
    render :new #render new post
  end

  def search
    #def amazonproductfind(searchtext)
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
        @searchresult.push search_item
      end
      respond_to do |format|
        format.html
        format.json { render :json => @searchresult }
      end


      #end

      def show
        @user= current_user
        @transaction = Transaction.find(params[:id])
        if user_signed_in?
          user_signed_in=true
        else
          user_signed_in=false
        end
        p params[:id]
        render :show
      end

    end
  end


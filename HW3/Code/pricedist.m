function price_cdf = pricedist(prices,grid, Delta)
    num_auctions = length(prices);
    price_cdf = zeros(length(grid),1);
    for i=1:length(grid)
        price_cdf(i) = (1/num_auctions)*sum(prices+Delta<= grid(i));
    end 
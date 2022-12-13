function value_cdf = valuedist(bidders,prices,grid,n,Delta)
    % Bidders and transaction prices for auctions with n bidders
    bid_ind = find(bidders == n); 
    prices  = prices(bid_ind);
    
    % Distribution of prices
    price_cdf = pricedist(prices,grid, Delta);

    % Initializing distribution of values
    value_cdf = zeros(length(grid),1);

    for i=1:length(grid)
        % Creating vector of coefficients
        p = zeros(n+1, 1); 
        p(end) = -1*price_cdf(i);
        p(1) = 1-n;
        p(2) = n;
        % finding the roots
        zer = roots(p);
        % Real part of roots (sometimes there is an issue with 0i
        zer = real(zer);
        % Roots should be within [0,1]
        zer = zer(zer >=0);
        zer = zer(zer<=1);
        if length(unique(zer)) >1
            disp('issue')
        end  
        value_cdf(i) = unique(zer);
    end
end
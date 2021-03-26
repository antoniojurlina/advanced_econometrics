function [summary data] = myMC(R, nobs, alphas, betas, omit)
    betas_MC = zeros(R,2);
    se_MC = zeros(R,2);
    tstats_MC = zeros(R,2);
    for r = 1:R;
        X_i = normrnd(10, 5, [nobs, 1]);
        e_1 = normrnd(0, 1, [nobs, 1]);
        e_2 = normrnd(0, 0.75^2, [nobs, 1]);
        D = alphas(1,1) + alphas(2,1)*X_i + e_2;
        
        if omit == 0
            X = [ones(nobs,1), X_i, D]; 
        else
            X = [ones(nobs,1), X_i]; 
        end;
        
        y = betas(1,1) + betas(2,1)*X_i + betas(3,1)*D + e_1;
        
        [bhat, se, r2] = myols(X,y); 
        betas_MC(r,:)= bhat(1:2,:);
        se_MC(r,:) = se(1:2,:);
        tstats_MC(r,:) = bhat(1:2,:)./se(1:2,:);
        
    end;

    T = table(mean(betas_MC(:,1:2))', std(betas_MC(:,1:2))', ...
              min(betas_MC(:,1:2))', max(betas_MC(:,1:2))');
    T.Properties.RowNames = {'Beta 0' 'Beta 1'};
    T.Properties.VariableNames = {'Mean' 'Std' 'Min' 'Max'};
    summary = T
    data = [betas_MC, se_MC, tstats_MC]
end

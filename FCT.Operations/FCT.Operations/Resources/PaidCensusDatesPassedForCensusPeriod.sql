SELECT
            	COUNT(*)
            FROM
            	PolicyCache.PolicyFundingStreamCensusDate cd
            	INNER JOIN PolicyCache.PolicyFundingStreamPeriod fsp ON fsp.FundingStreamPeriod = cd.FundingStreamPeriod
            WHERE
            	YEAR(cd.CensusDate) = YEAR(@currentTime)
            	AND MONTH(cd.CensusDate) = MONTH(@currentTime)
            	AND cd.CensusDate > @currentTime
            	AND fsp.PaymentMethod IN @pMethod
            	AND (fsp.ActivityCloseDate IS NULL OR fsp.ActivityCloseDate > @currentTime)
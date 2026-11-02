namespace Datafix.Tests
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Automation;
    using Dapper;

    public class SubnominalAggregationUpdateSubnominalCodePaas //: IApplyDataFix
    {
        public string Release => "R71";
        public int StoryNumber => 26707;
        public string Name => "SubnominalAggregation Update SubnominalCode PAAS";
        public int Order => 2;

        public void ApplyDataFix()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const int commandTimeoutInSeconds = 600;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"
                            UPDATE PaymentGeneration.SubnominalAggregation
                            SET SubnominalCode = '2240151', LastModifiedDate = getdate()
                            WHERE FundingStreamPeriodCode IN ('ANLAP2018','16-18NLAP2018')
                            AND PERIOD = '201908' 
	                        AND SubnominalCode = '2240150'
	                        AND NOT EXISTS (SELECT 1 FROM PaymentGeneration.SubnominalAggregation sa2
					                        WHERE sa2.PERIOD = '201908' 
					                        AND sa2.SubnominalCode = '2240151'
					                        AND sa2.PaymentType = PaymentGeneration.SubnominalAggregation.PaymentType
					                        AND sa2.AllocationNumber = PaymentGeneration.SubnominalAggregation.AllocationNumber)

                            UPDATE PaymentGeneration.SubnominalAggregation 
                            SET SubnominalCode = '2240161', LastModifiedDate = getdate()
                            WHERE FundingStreamPeriodCode IN ('ANLAP2018','16-18NLAP2018')
                            AND PERIOD = '201908' 
	                        AND SubnominalCode = '2240160'
	                        AND NOT EXISTS (SELECT 1 FROM PaymentGeneration.SubnominalAggregation sa2
					                        WHERE sa2.PERIOD = '201908' 
					                        AND sa2.SubnominalCode = '2240161'
					                        AND sa2.PaymentType = PaymentGeneration.SubnominalAggregation.PaymentType
					                        AND sa2.AllocationNumber = PaymentGeneration.SubnominalAggregation.AllocationNumber)

                            UPDATE PaymentGeneration.SubnominalAggregation 
                            SET SubnominalCode = '2340151', LastModifiedDate = getdate()
                            WHERE FundingStreamPeriodCode IN ('ANLAP2018','16-18NLAP2018')
                            AND PERIOD = '201908' 
	                        AND SubnominalCode = '2340150'
	                        AND NOT EXISTS (SELECT 1 FROM PaymentGeneration.SubnominalAggregation sa2
					                        WHERE sa2.PERIOD = '201908' 
					                        AND sa2.SubnominalCode = '2340151'
					                        AND sa2.PaymentType = PaymentGeneration.SubnominalAggregation.PaymentType
					                        AND sa2.AllocationNumber = PaymentGeneration.SubnominalAggregation.AllocationNumber)

                            UPDATE PaymentGeneration.SubnominalAggregation 
                            SET SubnominalCode = '2340161', LastModifiedDate = getdate()
                            WHERE FundingStreamPeriodCode IN ('ANLAP2018','16-18NLAP2018')
                            AND PERIOD = '201908' 
	                        AND SubnominalCode = '2340160'
	                        AND NOT EXISTS (SELECT 1 FROM PaymentGeneration.SubnominalAggregation sa2
					                        WHERE sa2.PERIOD = '201908' 
					                        AND sa2.SubnominalCode = '2340161'
					                        AND sa2.PaymentType = PaymentGeneration.SubnominalAggregation.PaymentType
					                        AND sa2.AllocationNumber = PaymentGeneration.SubnominalAggregation.AllocationNumber)
                                    ";

                connection.Execute(sql, commandTimeout: commandTimeoutInSeconds);
            }
        }
    }
}
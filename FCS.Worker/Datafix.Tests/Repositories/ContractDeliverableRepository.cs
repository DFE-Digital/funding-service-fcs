namespace Datafix.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using Datafix.Tests.Automation.Releases.R172;
    using schemas.sfa.gov.uk.cpds.gatewayservice;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class ContractDeliverableRepository
    {
        public static void UpdateContractDelvierables(
         string allocationNumber, string oldDeliverableCode, string newDelvierableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" UPDATE [ContractManagement].[ApprovedContractDeliverable] 
                                    SET DeliverableCode = @newDelvierableCode 
                                WHERE ContractAllocationNumber = @allocationNumber and DeliverableCode = @oldDeliverableCode";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, oldDeliverableCode, newDelvierableCode });
            }
        }

        public static void DeleteContractDelvierables(
        string allocationNumber, string oldDeliverableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" Delete FROM [ContractManagement].[ApprovedContractDeliverable] 
                                     
                                WHERE ContractAllocationNumber = @allocationNumber and DeliverableCode = @oldDeliverableCode 
                                    and ApprovedContractId in (126909,127665)";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, oldDeliverableCode });
            }
        }

        public static void DeleteSubnominalAggregation(
     string allocationNumber, string subnominalCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"Delete FROM PaymentGeneration.SubnominalAggregation                                
                                where AllocationNumber = @allocationNumber and SubnominalCode =@subnominalCode 
                                    and Period not in ('202308','202309')";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, subnominalCode });
            }
        }

        public static void DeleteDeliverablePayment(
     string allocationNumber, string oldDeliverableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" Delete FROM PaymentSchedule.DeliverablePayment
                             where AllocationNumber = @allocationNumber  and DeliverableCode =@oldDeliverableCode and VersionNumber  in (3,4) ";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, oldDeliverableCode });
            }
        }

        public static void UpdateContractSubnomialsDelvierables(
      string allocationNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" Update PaymentGeneration.SubnominalAggregation
                    set IsSelectedForPayment = 0, PostedFlag = 0,
                        AggregatedValue = 0 , LastModifiedDate = getdate()
                        where  paymenttype = 'RECONCILIATION' 
                    and AggregatedValue !=0 and AllocationNumber = @allocationNumber";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber });
            }
        }

        public static void UpdateContractDelvierablesPayment(
         string allocationNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" Update PaymentSchedule.DeliverablePayment 
                                set ReconciliationPaymentAmount = 0 , NetPaymentAmount = 0 
                                    ,LastModifiedDate = getdate()
                                where  ReconciliationPaymentAmount != 0 
                            and AllocationNumber = @allocationNumber ";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber });
            }
        }

        public static void InsertContractSubnomialsAggregationDelvierables(
  SubnominalAggregation subnominalAggregation)
        {
            string AllocationNumber = subnominalAggregation.AllocationNumber;
            string Period = subnominalAggregation.Period;
            string SubnominalCode = subnominalAggregation.SubnominalCode;
            string PaymentType = subnominalAggregation.PaymentType;
            string PeriodTypeCode = subnominalAggregation.PeriodTypeCode;
            string OrganisationId = subnominalAggregation.OrganisationId;
            string FundingStreamPeriodCode = subnominalAggregation.FundingStreamPeriodCode;
            int Ukprn = subnominalAggregation.Ukprn;
            bool PostedFlag = Convert.ToBoolean(subnominalAggregation.PostedFlag);
            decimal AggregatedValue = Convert.ToDecimal(subnominalAggregation.AggregatedValue);
            bool IsSelectedForPayment = Convert.ToBoolean(subnominalAggregation.IsSelectedForPayment);
            DateTime CreatedDate = DateTime.Now;
            int AllocationVersionNumber = Convert.ToInt32(subnominalAggregation.AllocationVersionNumber);

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" Insert into  PaymentGeneration.SubnominalAggregation
                    ( AllocationNumber,
                      Period	,
                        SubnominalCode	,
                        PaymentType	,
                        PeriodTypeCode	,
                        OrganisationId	,
                        FundingStreamPeriodCode	,
                        Ukprn	,
                        PostedFlag	,
                        AggregatedValue	,
                        IsSelectedForPayment,
                        CreatedDate	, 
                        AllocationVersionNumber)
                        Values(@AllocationNumber,
                                 @Period	,
                                 @SubnominalCode	,
                                 @PaymentType	,
                                 @PeriodTypeCode	,
                                 @OrganisationId	,
                                 @FundingStreamPeriodCode	,
                                 @Ukprn	,
                                 @PostedFlag	,
                                 @AggregatedValue	,
                                 @IsSelectedForPayment,
                                 @CreatedDate	, 
                                 @AllocationVersionNumber)";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new {
                        AllocationNumber,
                        Period,
                        SubnominalCode,
                        PaymentType,
                        PeriodTypeCode,
                        OrganisationId,
                        FundingStreamPeriodCode,
                        Ukprn,
                        PostedFlag,
                        AggregatedValue,
                        IsSelectedForPayment,
                        CreatedDate,
                        AllocationVersionNumber
                    });
            }
        }

    }
}

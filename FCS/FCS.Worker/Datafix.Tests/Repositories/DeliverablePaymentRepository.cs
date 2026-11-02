namespace Datafix.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Dapper;
    using Dtos;
    using MoreLinq;
    using schemas.sfa.gov.uk.cpds.gatewayservice;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    public static class DeliverablePaymentRepository
    {
        public static async Task<IReadOnlyCollection<DeliverablePaymentPlannedValue>> GetPlannedValueLines(
            string allocationNumber, int versionNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" select Period, DeliverableCode, PlannedValue from [PaymentSchedule].[DeliverablePayment]
                                where AllocationNumber = @allocationNumber
                                and VersionNumber = @versionNumber";

            using (var connection = new SqlConnection(connectionString))
            {
                var deliverablePayments =
                    await connection.QueryAsync<DeliverablePaymentPlannedValue>(sql,
                        new { allocationNumber, versionNumber }).ConfigureAwait(false);

                return deliverablePayments.ToList();
            }
        }

        public static void RemoveRowsForAllocationVersion(
            string allocationNumber, int versionNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @" Delete from [PaymentSchedule].[DeliverablePayment]
                                where AllocationNumber = @allocationNumber
                                and VersionNumber = @versionNumber";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, versionNumber });

            }
        }
        public static void UpdateRowsForAllocationVersion(
          string allocationNumber, string olddeliverableCode, string newdeliverableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"UPDATE PaymentSchedule.DeliverablePayment 
                                set DeliverableCode = @newdeliverableCode 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @olddeliverableCode";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, olddeliverableCode, newdeliverableCode });

            }
        }

        public static void UpdateAmountsForAllocationVersion(
          string allocationNumber, string deliverableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = ProfilePaymentAmount , BalancingPaymentAmount = 0.00 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = '202311'";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, deliverableCode });

            }
        }

        public static decimal? SelectBalAmountsForDecAllocationVersion(
          string allocationNumber, string deliverableCode, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @"Select BalancingPaymentAmount
                                        From PaymentSchedule.DeliverablePayment 
                                        Where AllocationNumber = @allocationNumber
                                        and DeliverableCode = @deliverableCode
                                        and Period = @period";

            decimal? balAmt = null;
            using (var connection = new SqlConnection(connectionString))
            {
                balAmt =
                   connection.Query<decimal?>(sqlSelect,
                     new { allocationNumber, deliverableCode, period }).FirstOrDefault();
                return balAmt;
            }
        }

        public static decimal? SelectBalAmountsForDecAllocationLatestVersion(
         string allocationNumber, string deliverableCode, string period, int? versionNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @"Select BalancingPaymentAmount
                                        From PaymentSchedule.DeliverablePayment 
                                        Where AllocationNumber = @allocationNumber
                                        and DeliverableCode = @deliverableCode
                                        and VersionNumber = @versionNumber
                                        and Period = @period";

            decimal? balAmt = null;
            using (var connection = new SqlConnection(connectionString))
            {
                balAmt =
                   connection.Query<decimal?>(sqlSelect,
                     new { allocationNumber, deliverableCode, period, versionNumber }).FirstOrDefault();
                return balAmt;
            }
        }


        public static void UpdateAmountsForDecAllocationVersion(
          string allocationNumber, string deliverableCode, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sql = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = ProfilePaymentAmount , BalancingPaymentAmount = 0.00 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, deliverableCode, period });

            }
        }

        public static void UpdateAmountsForDecAllocationLatestVersion(
         string allocationNumber, string deliverableCode, string period, int? versioNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sql = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = ProfilePaymentAmount , BalancingPaymentAmount = 0.00 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and VersionNumber = @versioNumber
                                and Period = @period";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, deliverableCode, period, versioNumber });

            }
        }

        public static void UpdateAmountsForDecAllocationVersionclawback(
         string allocationNumber, string deliverableCode, string period, DeliveryPayments deliveryPayment)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            decimal? netPayment = deliveryPayment.NetPaymentAmount;
            decimal? balAmount = deliveryPayment.BalancingpaymentAmount;
            const string sql = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = @netPayment , BalancingPaymentAmount = @balAmount
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period 
                                and VersionNumber > 1 ";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, deliverableCode, period, netPayment, balAmount });

            }
        }

        public static void UpdateAmountsForDecAllocationVersion16ED6009(
         string allocationNumber, string deliverableCode, string period, DeliveryPayments deliveryPayment)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            decimal? profilePayment = deliveryPayment.ProfilePaymentAmount;
            decimal? netPayment = deliveryPayment.NetPaymentAmount;
            decimal? balAmount = deliveryPayment.BalancingpaymentAmount;
            const string sql = @"update PaymentSchedule.DeliverablePayment
                                set ProfilePaymentAmount= @profilePayment, NetPaymentAmount = @netPayment , BalancingPaymentAmount = @balAmount
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period 
                                and VersionNumber > 2 ";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, deliverableCode, period, netPayment, balAmount, profilePayment });

            }
        }

        public static DeliveryPayments GePaymentValues(string allocationNumber, string deliverableCode, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sqlSelect = @"Select Top 1 PlannedValue, ProfilePaymentAmount,BalancingPaymentAmount,NetPaymentAmount 
                                        From PaymentSchedule.DeliverablePayment 
                                        Where AllocationNumber= @allocationNumber 
                                        And Period = @period
                                        And DeliverableCode = @deliverableCode 
                                        Order by CreatedDate  asc ";

            using (var connection = new SqlConnection(connectionString))
            {
                var deliverablePayment =
                    connection.Query<DeliveryPayments>(sqlSelect,
                      new { allocationNumber, deliverableCode, period }).FirstOrDefault();

                return deliverablePayment;
            }
        }

        public static DeliveryPayments GePaymentValuesFor16ED6172(string allocationNumber, string deliverableCode, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sqlSelect = @"Select Top 1 PlannedValue, ProfilePaymentAmount,BalancingPaymentAmount,NetPaymentAmount 
                                        From PaymentSchedule.DeliverablePayment 
                                        Where AllocationNumber= @allocationNumber 
                                        And Period = @period
                                        And DeliverableCode = @deliverableCode 
                                        And VersionNumber = 3
                                        Order by CreatedDate  asc ";

            using (var connection = new SqlConnection(connectionString))
            {
                var deliverablePayment =
                    connection.Query<DeliveryPayments>(sqlSelect,
                      new { allocationNumber, deliverableCode, period }).FirstOrDefault();

                deliverablePayment.ProfilePaymentAmount = deliverablePayment.PlannedValue;
                deliverablePayment.NetPaymentAmount = deliverablePayment.BalancingpaymentAmount;
                return deliverablePayment;
            }
        }


        public static void UpdateAugSepAmountsForAllocationVersion(
        string allocationNumber, string deliverableCode, DeliveryPayments deliveryPayment, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            decimal? netPayment = deliveryPayment.NetPaymentAmount;
            decimal? balAmount = deliveryPayment.BalancingpaymentAmount;
            decimal? profileNetpayment = deliveryPayment.ProfilePaymentAmount;

            if (profileNetpayment != null)
            {
                const string sqlProfile = @"UPDATE PaymentSchedule.DeliverablePayment
                                set  ProfilePaymentAmount = @profileNetpayment
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period";
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sqlProfile,
                        new { allocationNumber, deliverableCode, profileNetpayment, period });
                }
            }
            if (balAmount != null)
            {
                const string sqlBal = @"UPDATE PaymentSchedule.DeliverablePayment
                                set BalancingPaymentAmount = @balAmount 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period";
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sqlBal,
                        new { allocationNumber, deliverableCode, balAmount, period });
                }
            }
            if (netPayment != null)
            {
                const string sqlnet = @"UPDATE PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = @netPayment
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period";
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sqlnet,
                        new { allocationNumber, deliverableCode, netPayment, period });
                }
            }
        }
        public static void UpdateAugSepAmountsForAllocationVersion1619ED6172(
              string allocationNumber, string deliverableCode, DeliveryPayments deliveryPayment, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            decimal? netPayment = deliveryPayment.NetPaymentAmount;
            decimal? balAmount = deliveryPayment.BalancingpaymentAmount;
            decimal? profileNetpayment = deliveryPayment.ProfilePaymentAmount;

            if (profileNetpayment != null)
            {
                const string sqlProfile = @"UPDATE PaymentSchedule.DeliverablePayment
                                set  ProfilePaymentAmount = @profileNetpayment
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period
                                and VersionNumber >= 3 ";
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sqlProfile,
                        new { allocationNumber, deliverableCode, profileNetpayment, period });
                }
            }
            if (balAmount != null)
            {
                const string sqlBal = @"UPDATE PaymentSchedule.DeliverablePayment
                                set BalancingPaymentAmount = @balAmount 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period 
                                and VersionNumber >= 3 ";
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sqlBal,
                        new { allocationNumber, deliverableCode, balAmount, period });
                }
            }
            if (netPayment != null)
            {
                const string sqlnet = @"UPDATE PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = @netPayment
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = @period 
                                and VersionNumber >= 3 ";
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sqlnet,
                        new { allocationNumber, deliverableCode, netPayment, period });
                }
            }
        }

        public static void UpdateAugSepAmountsForAllocationVersion1(
         string allocationNumber, string deliverableCode, int? versionNumber)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sqlSelect = @" select PlannedValue from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and    DeliverableCode = @deliverableCode
                                and   Period ='202308'  and VersionNumber = @versionNumber ";
            string plannedValue = null;
            using (var connection = new SqlConnection(connectionString))
            {
                plannedValue =
                      connection.Query<string>(sqlSelect, new { allocationNumber, deliverableCode, versionNumber }).FirstOrDefault();
            }
            if (plannedValue != null && plannedValue != "0.00")
            {
                const string sqlSelectNetPaymentAmtAug = @" select Top 1  ProfilePaymentAmount from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and    DeliverableCode = @deliverableCode
                                and   Period ='202308' ";
                string NetAmtAug = null;
                using (var connection = new SqlConnection(connectionString))
                {
                    NetAmtAug =
                          connection.Query<string>(sqlSelectNetPaymentAmtAug, new { allocationNumber, deliverableCode, versionNumber }).FirstOrDefault();
                }
                if (NetAmtAug != null && Convert.ToDecimal(NetAmtAug) > 0)
                {
                    const string sqlAug = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = PlannedValue , ProfilePaymentAmount = PlannedValue
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = '202308'";
                    using (var connection = new SqlConnection(connectionString))
                    {
                        connection.Execute(sqlAug,
                            new { allocationNumber, deliverableCode });
                    }
                }
                const string sqlSelectNetPaymentSepAug = @" select Top 1  ProfilePaymentAmount  from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and    DeliverableCode = @deliverableCode
                                and   Period ='202309'  ";
                string NetAmtSep = null;
                using (var connection = new SqlConnection(connectionString))
                {
                    NetAmtSep =
                          connection.Query<string>(sqlSelectNetPaymentSepAug, new { allocationNumber, deliverableCode, versionNumber }).FirstOrDefault();
                }
                if (NetAmtSep == null && Convert.ToDecimal(NetAmtSep) > 0)
                {
                    const string sqlSep = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = PlannedValue , ProfilePaymentAmount = PlannedValue
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = '202309'";

                    using (var connection = new SqlConnection(connectionString))
                    {
                        connection.Execute(sqlSep,
                           new { allocationNumber, deliverableCode });

                    }
                }
                if (allocationNumber == "16ED-6172")
                {
                    Update16ED6172AggregateAmountForSubnominalAggregations(allocationNumber, versionNumber, deliverableCode);
                }
            }
            else
            {
                //Aug
                const string sqlSelectplannedvalue = @" select top 1 ProfilePaymentAmount  from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and    DeliverableCode = @deliverableCode
                                and   Period ='202308' ";
                string plannedValueAmt = null;
                using (var connection = new SqlConnection(connectionString))
                {
                    plannedValueAmt =
                          connection.Query<string>(sqlSelectplannedvalue, new { allocationNumber, deliverableCode }).FirstOrDefault();
                }
                if (plannedValueAmt == null)
                {
                    plannedValueAmt = "0";
                }

                const string sqldelAllocationNo = @"select AllocationNumber from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and    DeliverableCode = @deliverableCode
                                and   Period ='202308' and VersionNumber = @versionNumber";
                string allno = null;
                using (var connection = new SqlConnection(connectionString))
                {
                    allno =
                          connection.Query<string>(sqldelAllocationNo, new { allocationNumber, deliverableCode, versionNumber }).FirstOrDefault();
                }
                int? augversion = versionNumber;
                if (allno == null)
                {
                    augversion = versionNumber - 1;
                }
                const string sqlAug = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = @plannedValueAmt , ProfilePaymentAmount = @plannedValueAmt 
                                    ,PlannedValue = @plannedValueAmt 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = '202308'  and VersionNumber = @augversion";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sqlAug,
                        new { allocationNumber, deliverableCode, plannedValueAmt, augversion });
                }


                //sep
                const string sqlSelectplannedSepvalue = @" select top 1 ProfilePaymentAmount  from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and    DeliverableCode = @deliverableCode
                                and   Period ='202309' ";
                string sepplannedValueAmt = null;
                using (var connection = new SqlConnection(connectionString))
                {
                    sepplannedValueAmt =
                          connection.Query<string>(sqlSelectplannedSepvalue, new { allocationNumber, deliverableCode }).FirstOrDefault();
                }
                if (allocationNumber == "16ED-6172")
                {
                    Update16ED6172AggregateAmountForSubnominalAggregations(allocationNumber, versionNumber, deliverableCode);
                }
                else
                {
                    if (sepplannedValueAmt == null)
                    {
                        sepplannedValueAmt = "0";
                    }
                    const string sqldelAllocationNosep = @"select AllocationNumber from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and    DeliverableCode = @deliverableCode
                                and   Period ='202309' and VersionNumber = @versionNumber";
                    string allnoSep = null;
                    using (var connection = new SqlConnection(connectionString))
                    {
                        allnoSep =
                              connection.Query<string>(sqldelAllocationNosep, new { allocationNumber, deliverableCode, versionNumber }).FirstOrDefault();
                    }
                    int? sepVersion = versionNumber;
                    if (allnoSep == null)
                    {
                        sepVersion = versionNumber - 1;
                    }
                    const string sqlSep = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = @sepplannedValueAmt , ProfilePaymentAmount = @sepplannedValueAmt 
                                    ,PlannedValue = @sepplannedValueAmt 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = '202309'   and VersionNumber = @sepVersion";

                    using (var connection = new SqlConnection(connectionString))
                    {
                        connection.Execute(sqlSep,
                            new { allocationNumber, deliverableCode, sepplannedValueAmt, sepVersion });
                    }
                }

            }
        }
        public static void UpdateAmountsForSubnominalAggregationAllocationVersion(
      string allocationNumber, string deliverableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"update PaymentGeneration.SubnominalAggregation
                                set NetPaymentAmount = ProfilePaymentAmount , BalancingPaymentAmount = 0.00 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @deliverableCode
                                and Period = '202310'";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql,
                    new { allocationNumber, deliverableCode });

            }
        }

        public static void DeleteRowsForSubnominalAggregations(
        string allocationNumber, string oldSubnominalCode, string newSubnominalCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select SubnominalCode from PaymentGeneration.SubnominalAggregation
                                where AllocationNumber = @allocationNumber
                                and    SubnominalCode = @newSubnominalCode";
            List<string> subnominalcode = null;
            using (var connection = new SqlConnection(connectionString))
            {
                subnominalcode =
                      connection.Query<string>(sqlSelect, new { allocationNumber, newSubnominalCode }).ToList();
            }
            if (subnominalcode.Any())
            {
                const string sql = @"Delete from PaymentGeneration.SubnominalAggregation 
                                where AllocationNumber =@allocationNumber and 
                                SubnominalCode = @oldSubnominalCode and Period not in('202308','202309')";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, oldSubnominalCode });

                }
            }
        }

        public static void DeleteAugRowsForSubnominalAggregations(
       string allocationNumber, string oldSubnominalCode, string newSubnominalCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select SubnominalCode from PaymentGeneration.SubnominalAggregation
                                where AllocationNumber = @allocationNumber
                                and    SubnominalCode = @newSubnominalCode and Period = '202308'";
            List<string> subnominalcode = null;
            using (var connection = new SqlConnection(connectionString))
            {
                subnominalcode =
                      connection.Query<string>(sqlSelect, new { allocationNumber, newSubnominalCode }).ToList();
            }
            if (subnominalcode.Any())
            {
                const string sql = @"Delete from PaymentGeneration.SubnominalAggregation 
                                where AllocationNumber =@allocationNumber and 
                                SubnominalCode = @oldSubnominalCode and Period = '202308'";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, oldSubnominalCode });

                }
            }
        }

        public static void DeleteSepRowsForSubnominalAggregations(
    string allocationNumber, string oldSubnominalCode, string newSubnominalCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select SubnominalCode from PaymentGeneration.SubnominalAggregation
                                where AllocationNumber = @allocationNumber
                                and    SubnominalCode = @newSubnominalCode and Period = '202309'";
            List<string> subnominalcode = null;
            using (var connection = new SqlConnection(connectionString))
            {
                subnominalcode =
                      connection.Query<string>(sqlSelect, new { allocationNumber, newSubnominalCode }).ToList();
            }
            if (subnominalcode.Any())
            {
                const string sql = @"Delete from PaymentGeneration.SubnominalAggregation 
                                where AllocationNumber =@allocationNumber and 
                                SubnominalCode = @oldSubnominalCode and Period = '202309'";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, oldSubnominalCode });

                }
            }
        }

        public static void UpdateSubnominalForSubnominalAggregations(
      string allocationNumber, string oldSubnominalCode, string newSubnominalCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select SubnominalCode from PaymentGeneration.SubnominalAggregation
                                where AllocationNumber = @allocationNumber
                                and    SubnominalCode = @newSubnominalCode";
            List<string> subnominalcode = null;
            using (var connection = new SqlConnection(connectionString))
            {
                subnominalcode =
                      connection.Query<string>(sqlSelect, new { allocationNumber, newSubnominalCode }).ToList();
            }
            if (!subnominalcode.Any())
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET SubnominalCode = @newSubnominalCode
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @oldSubnominalCode ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, oldSubnominalCode, newSubnominalCode });

                }
            }
        }

        public static void UpdateSepSubnominalForSubnominalAggregations(
      string allocationNumber, string oldSubnominalCode, string newSubnominalCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select SubnominalCode from PaymentGeneration.SubnominalAggregation
                                where AllocationNumber = @allocationNumber
                                and    SubnominalCode = @newSubnominalCode and period ='202309'";
            List<string> subnominalcode = null;
            using (var connection = new SqlConnection(connectionString))
            {
                subnominalcode =
                      connection.Query<string>(sqlSelect, new { allocationNumber, newSubnominalCode }).ToList();
            }
            if (!subnominalcode.Any())
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET SubnominalCode = @newSubnominalCode
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @oldSubnominalCode and period ='202309' ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, oldSubnominalCode, newSubnominalCode });

                }
            }
        }

        public static void UpdateAugSubnominalForSubnominalAggregations(
    string allocationNumber, string oldSubnominalCode, string newSubnominalCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select SubnominalCode from PaymentGeneration.SubnominalAggregation
                                where AllocationNumber = @allocationNumber
                                and    SubnominalCode = @newSubnominalCode and period ='202308'";
            List<string> subnominalcode = null;
            using (var connection = new SqlConnection(connectionString))
            {
                subnominalcode =
                      connection.Query<string>(sqlSelect, new { allocationNumber, newSubnominalCode }).ToList();
            }
            if (!subnominalcode.Any())
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET SubnominalCode = @newSubnominalCode
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @oldSubnominalCode and period ='202308' ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, oldSubnominalCode, newSubnominalCode });

                }
            }
        }

        public static void UpdateAggregateAmountDecForSubnominalAggregations(
      string allocationNumber, string newSubnominalCode, int? contractVersion, string newDeliverlableCode, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            string aggregatedValue = SelectPaymentValueFromDeliverPayment(allocationNumber, contractVersion, newDeliverlableCode, period);
            if (aggregatedValue != null)
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET AggregatedValue = @aggregatedValue
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @newSubnominalCode and period =@period ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, newSubnominalCode, aggregatedValue, period });

                }
            }
        }

        public static void UpdatePostedFlagforZEROAggregateAmount()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sql = @"UPDATE  PaymentGeneration.SubnominalAggregation 
                                     SET PostedFlag = 0 , IsSelectedForPayment = 0
                                    WHERE IsSelectedForPayment = 1 and AggregatedValue = 0 and AllocationNumber like '%16ED%' ";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql);
            }
        }

        public static void UpdateAggregateAmountForSubnominalAggregations(
      string allocationNumber, string newSubnominalCode, int? contractVersion, string newDeliverlableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            string aggregatedValue = SelectPaymentValueFromDeliverPayment(allocationNumber, contractVersion, newDeliverlableCode, "202310");
            if (aggregatedValue != null)
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET AggregatedValue = @aggregatedValue
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @newSubnominalCode and period ='202310' ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, newSubnominalCode, aggregatedValue });

                }
            }
        }

        public static void UpdateAugSepSubnominalAggregations(
 string allocationNumber, string newSubnominalCode, DeliveryPayments deliveryPayment, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            decimal? netPyamentAmt = deliveryPayment.NetPaymentAmount;
            if (netPyamentAmt != null)
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET AggregatedValue = @netPyamentAmt
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @newSubnominalCode and period =@period ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, newSubnominalCode, netPyamentAmt, period });

                }
            }
        }
        public static void UpdateAugSepAggregateAmountForSubnominalAggregations(
string allocationNumber, string newSubnominalCode, int? contractVersion, string newDeliverlableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            string aggregatedValue = SelectAugSepPaymentValueFromDeliverPayment(allocationNumber, contractVersion, newDeliverlableCode, "202308");
            if (aggregatedValue != null)
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET AggregatedValue = @aggregatedValue
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @newSubnominalCode and period ='202308' ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, newSubnominalCode, aggregatedValue });

                }
            }

            //sep

            string aggregatedValueSep = SelectAugSepPaymentValueFromDeliverPayment(allocationNumber, contractVersion, newDeliverlableCode, "202309");
            if (aggregatedValue != null)
            {
                const string sql = @"UPDATE PaymentGeneration.SubnominalAggregation 
                            SET AggregatedValue = @aggregatedValueSep
                            Where AllocationNumber =@allocationNumber  and SubnominalCode = @newSubnominalCode and period ='202309' ";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, newSubnominalCode, aggregatedValueSep });

                }
            }
        }

        public static void Update16ED6172AggregateAmountForSubnominalAggregations(
 string allocationNumber, int? contractVersion, string newDeliverlableCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @"select  BalancingPaymentAmount from	PaymentSchedule.DeliverablePayment                                
                                    where AllocationNumber = @allocationNumber and period ='202309'
                                    and DeliverableCode = @newDeliverlableCode
								    and BalancingPaymentAmount < 0 ";
            string balAmt = null;
            using (var connection = new SqlConnection(connectionString))
            {
                balAmt =
                      connection.Query<string>(sqlSelect, new { allocationNumber, contractVersion, newDeliverlableCode }).FirstOrDefault();
            }
            if (balAmt != null && Convert.ToDecimal(balAmt) < 0)
            {
                const string sql = @"update PaymentSchedule.DeliverablePayment
                                set NetPaymentAmount = @balAmt , ProfilePaymentAmount = @balAmt 
                                    ,PlannedValue = 0 
                                where AllocationNumber = @allocationNumber
                                and DeliverableCode = @newDeliverlableCode
                                and Period = '202309'   and VersionNumber = @contractVersion";

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Execute(sql,
                        new { allocationNumber, newDeliverlableCode, contractVersion, balAmt });

                }
            }
        }

        public static string SelectPaymentValueFromDeliverPayment(
       string allocationNumber, int? contractVersion, string newDeliverlableCode, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select NetPaymentAmount from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and  VersionNumber  = @contractVersion 
                                and DeliverableCode = @newDeliverlableCode
                                and  period =@period ";
            string aggregateValue = null;
            using (var connection = new SqlConnection(connectionString))
            {
                aggregateValue =
                      connection.Query<string>(sqlSelect, new { allocationNumber, contractVersion, newDeliverlableCode, period }).FirstOrDefault();
            }
            if (aggregateValue == null && contractVersion > 1)
            {
                contractVersion = contractVersion - 1;
                const string sqlSelectnew = @" select NetPaymentAmount from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and  VersionNumber  = @contractVersion 
                                and DeliverableCode = @newDeliverlableCode
                                and  period =@period ";
                string aggregateValueamt = null;
                using (var connection = new SqlConnection(connectionString))
                {
                    aggregateValueamt =
                          connection.Query<string>(sqlSelectnew, new { allocationNumber, contractVersion, newDeliverlableCode, period }).FirstOrDefault();
                }
                return aggregateValueamt;
            }
            return aggregateValue;
        }

        public static string SelectAugSepPaymentValueFromDeliverPayment(
     string allocationNumber, int? contractVersion, string newDeliverlableCode, string period)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select NetPaymentAmount from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and  VersionNumber  = @contractVersion 
                                and DeliverableCode = @newDeliverlableCode
                                and  period =@period ";
            string aggregateValue = null;
            using (var connection = new SqlConnection(connectionString))
            {
                aggregateValue =
                      connection.Query<string>(sqlSelect, new { allocationNumber, contractVersion, newDeliverlableCode, period }).FirstOrDefault();
            }
            if (aggregateValue == null && contractVersion > 1)
            {
                SelectAugSepPaymentValueFromDeliverPayment(allocationNumber, contractVersion - 1, newDeliverlableCode, period);

            }
            return aggregateValue;
        }

        public static List<DeliveryPaymentObj> GeDeliveryPaymentValues(string allocationNumber, string deliverableCode, string preVerstion)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @"Select * 
                                        From PaymentSchedule.DeliverablePayment 
                                        Where AllocationNumber= @allocationNumber
                                        And DeliverableCode != @deliverableCode 
                                        And VersionNumber = @preVerstion
                                        Order by CreatedDate  asc ";

            using (var connection = new SqlConnection(connectionString))
            {
                var deliverablePayment =
                    connection.Query<DeliveryPaymentObj>(sqlSelect,
                      new { allocationNumber, deliverableCode, preVerstion }).ToList();

                return deliverablePayment;
            }
        }
        public static List<string> SelectDelPamentByALlocationNo(
     string allocationNumber, string contractVersion, string delCode)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            const string sqlSelect = @" select AllocationNumber from PaymentSchedule.DeliverablePayment
                                where AllocationNumber = @allocationNumber
                                and  VersionNumber  = @contractVersion And DeliverableCode != @delCode";
            List<string> result = null;
            using (var connection = new SqlConnection(connectionString))
            {
                result =
                      connection.Query<string>(sqlSelect, new { allocationNumber, contractVersion, delCode }).ToList();
            }
            return result;
        }
        public static void AddDeliverablePaymentsForAllocation(List<DeliveryPaymentObj> deliverablePayments, string allocationNumber, string version, string InsertedDelCode)
        {

            var connectionString = ConfigurationManager.ConnectionStrings["PaymentSchedulePolicyContext"].ConnectionString;

            
            using (var connection = new SqlConnection(connectionString))
            {
                var existingPayments = SelectDelPamentByALlocationNo(allocationNumber, version, InsertedDelCode);
                if (!existingPayments.Any())
                {
                    deliverablePayments.ForEach(dp =>
                {
                    string AllocationNumber = dp.AllocationNumber;
                    int VersionNumber = Convert.ToInt32(version);
                    int DeliverableCode = dp.DeliverableCode;
                    string Period = dp.Period;
                    int PeriodTypeCode = dp.PeriodTypeCode;
                    decimal? PlannedVolume = dp.PlannedVolume;
                    decimal? PlannedValue = dp.PlannedValue;
                    decimal? ProfilePaymentAmount = dp.ProfilePaymentAmount;
                    decimal? CappedPaymentAmount = dp.CappedPaymentAmount;
                    decimal? BalancingPaymentAmount = dp.BalancingPaymentAmount;
                    decimal? ReconciliationPaymentAmount = dp.ReconciliationPaymentAmount;
                    decimal? NetPaymentAmount = dp.NetPaymentAmount;
                    string CollectionReturnCode = dp.CollectionReturnCode;
                    decimal? ActualVolume = dp.ActualVolume;
                    decimal? ActualValue = dp.ActualValue;
                    DateTime CreatedDate = dp.CreatedDate;

                    const string sql = @"INSERT INTO PaymentSchedule.DeliverablePayment (
                                                AllocationNumber,
                                                VersionNumber,
                                                DeliverableCode,
                                                Period,
                                                PeriodTypeCode,
                                                PlannedVolume,
                                                PlannedValue,
                                                ProfilePaymentAmount,
                                                CappedPaymentAmount,
                                                BalancingPaymentAmount,
                                                ReconciliationPaymentAmount,
                                                NetPaymentAmount,
                                                CollectionReturnCode,
                                                ActualVolume,
                                                ActualValue,
                                    CreatedDate ) values (@AllocationNumber, @VersionNumber,@DeliverableCode, @Period, @PeriodTypeCode,
                                    @PlannedVolume, @PlannedValue,@ProfilePaymentAmount, @CappedPaymentAmount, @BalancingPaymentAmount,
                                    @ReconciliationPaymentAmount, @NetPaymentAmount,@CollectionReturnCode, @ActualVolume, @ActualValue,@CreatedDate );"
                    ;

                    connection.Execute(sql, new
                    {
                        AllocationNumber,
                        VersionNumber,
                        DeliverableCode,
                        Period,
                        PeriodTypeCode,
                        PlannedVolume,
                        PlannedValue,
                        ProfilePaymentAmount,
                        CappedPaymentAmount,
                        BalancingPaymentAmount,
                        ReconciliationPaymentAmount,
                        NetPaymentAmount,
                        CollectionReturnCode,
                        ActualVolume,
                        ActualValue,
                        CreatedDate
                    });

                });
                }
            }
        }
    }
}
